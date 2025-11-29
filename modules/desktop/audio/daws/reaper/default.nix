{ pkgs, lib, config, user, inputs, ... }:
let
  # TODO: package to nurpkgs
  margesimpson = inputs.margesimpson.packages.${pkgs.stdenv.targetPlatform.system}.default;

  desktopCfg = config.modules.desktop;
  cfg = desktopCfg.audio.daws.reaper;

  # 1st method of config applying: append lines and remove duplicates
  # why reaper-kb.ini: properties do not have a value
  # TODO: auto old script removal???
  # TODO: auto removal of duplicate keybinds

  configApplyingScript = lib.mapAttrsToList (name: value: ''
    ${margesimpson}/bin/margesimpson -t .config/REAPER/${name} ${pkgs.writeText "${name}-patches" value}
  '') (lib.removeAttrs cfg.config [ "reaper-kb.ini" ]);

  reaper-wrapped = pkgs.writeScriptBin "reaper" /* bash */ ''
    ${lib.optionalString desktopCfg.audio.plugins.wine.enable "wine-audio-plugins-activate"}

    ${lib.concatStringsSep "\n" configApplyingScript}

    ${pkgs.reaper}/bin/reaper $@
  '';
in {
  options.modules.desktop.audio.daws.reaper = {
    enable = lib.mkEnableOption "REAPER";

    config = lib.mkOption {
      type = with lib.types; attrsOf lines;
      default = { };
    };
  };

  imports = [
    ./extensions
    ./scripts
    ./theme
    ./config.nix
  ];

  config = lib.mkIf cfg.enable {
    _internals.isAnyDawInstalled = true;

    home-manager.users.${user} = {
      home.packages = [ reaper-wrapped ];
    };
  };
}

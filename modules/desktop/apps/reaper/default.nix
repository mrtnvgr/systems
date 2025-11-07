{ pkgs, lib, config, user, ... }:
let
  inherit (lib) mkEnableOption mkOption types;

  # inherit (inputs.margesimpson.${pkgs.system}) margesimpson;
  # TODO: modular config via margesimpson

  cfg = config.modules.desktop.apps.reaper;

  reaper-wrapped = pkgs.writeScriptBin "reaper" /* bash */ ''
    echo Running preRun hook...
    ${cfg.extraPreRunScript}

    ${pkgs.reaper}/bin/reaper $@
  '';
in {
  options.modules.desktop.apps.reaper = {
    enable = mkEnableOption "reaper";

    extraPreRunScript = mkOption {
      type = types.str;
      default = "";
    };
  };

  imports = [
    ./theme.nix
    ./reascripts.nix
  ];

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ reaper-wrapped ];
    };

    # TODO: gc deletes plugins
    # TODO: link files via hm
    # TODO: .wine-nix/reaper/{regs, data, plugins}
    # TODO: prefix without dxvk?
  };
}

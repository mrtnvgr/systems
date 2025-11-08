{ pkgs, lib, config, user, ... }:
let
  # inherit (inputs.margesimpson.${pkgs.system}) margesimpson;
  # TODO: modular config via margesimpson

  desktopCfg = config.modules.desktop;
  cfg = desktopCfg.apps.reaper;

  reaper-wrapped = pkgs.writeScriptBin "reaper" /* bash */ ''
    ${lib.optionalString desktopCfg.audio.plugins.wine.enable "wine-audio-plugins-activate"}
    ${pkgs.reaper}/bin/reaper $@
  '';
in {
  options.modules.desktop.apps.reaper = {
    enable = lib.mkEnableOption "reaper";
  };

  imports = [
    ./theme.nix
    ./reascripts.nix
  ];

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ reaper-wrapped ];
    };
  };
}

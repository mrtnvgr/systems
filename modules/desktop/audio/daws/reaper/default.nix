{ pkgs, lib, config, user, ... }:
let
  # inherit (inputs.margesimpson.${pkgs.system}) margesimpson;
  # TODO: modular config via margesimpson

  desktopCfg = config.modules.desktop;
  cfg = desktopCfg.audio.daws.reaper;

  reaper-wrapped = pkgs.writeScriptBin "reaper" /* bash */ ''
    ${lib.optionalString desktopCfg.audio.plugins.wine.enable "wine-audio-plugins-activate"}
    ${pkgs.reaper}/bin/reaper $@
  '';
in {
  options.modules.desktop.audio.daws.reaper = {
    enable = lib.mkEnableOption "REAPER";
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

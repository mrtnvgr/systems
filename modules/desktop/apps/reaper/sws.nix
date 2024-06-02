{ pkgs, lib, config, user, ... }: let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.apps.reaper;
  arch = pkgs.stdenv.targetPlatform.linuxArch;
in {
  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.file.".config/REAPER/UserPlugins/reaper_sws-${arch}.so".source = "${pkgs.reaper-sws-extension}/UserPlugins/reaper_sws-${arch}.so";
      home.file.".config/REAPER/Scripts/sws_python.py".source = "${pkgs.reaper-sws-extension}/Scripts/sws_python.py";
      home.file.".config/REAPER/Scripts/sws_python64.py".source = "${pkgs.reaper-sws-extension}/Scripts/sws_python64.py";
    };
  };
}

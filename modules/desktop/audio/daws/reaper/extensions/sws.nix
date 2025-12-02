{ lib, config, user, pkgs, ... }:
let
  cfg = config.modules.desktop.audio.daws.reaper;

  sws-version = pkgs.reaper-sws-extension.version;

  sws-win = pkgs.fetchurl {
    url = "https://github.com/reaper-oss/sws/releases/download/v${sws-version}/reaper_sws-x64.dll";
    hash = "sha256-tSFWc1sh5SOnVVNbHm8ZiHyHAcvo+pb7+Qtue0dJ1fg=";
  };
in {
  options.modules.desktop.audio.daws.reaper = {
    extensions.sws.enable = lib.mkEnableOption "REAPER SWS extension";
  };

  config = lib.mkIf cfg.extensions.sws.enable {
    home-manager.users.${user} = {
      home.file.".config/REAPER/UserPlugins/reaper_sws-x86_64.so".source = "${pkgs.reaper-sws-extension}/UserPlugins/reaper_sws-x86_64.so";
      home.file.".config/REAPER/UserPlugins/reaper_sws-x64.dll".source = sws-win;

      home.file.".config/REAPER/Scripts/sws_python64.py".source = "${pkgs.reaper-sws-extension}/Scripts/sws_python64.py";
      home.file.".config/REAPER/Scripts/sws_python.py".source = "${pkgs.reaper-sws-extension}/Scripts/sws_python.py";
    };
  };
}

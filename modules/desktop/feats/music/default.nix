{ pkgs, lib, config, user, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.modules.desktop.feats.music;
in {
  options.modules.desktop.feats.music = {
    enable = mkEnableOption "music player";
    path = mkOption {
      type = with types; nullOr str;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      services.mpd.enable = true;
      services.mpd.musicDirectory = cfg.path;

      programs.ncmpcpp = {
        enable = true;
        mpdMusicDir = cfg.path;
      };

      home.packages = with pkgs; [ mpc-cli ];
    };
  };
}

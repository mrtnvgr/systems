{ pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.desktop.feats.rclone;

  musicPath = config.modules.desktop.feats.music.path;
  sync-music = pkgs.writeScriptBin "sync-music" ''
    ${pkgs.rclone}/bin/rclone -P --timeout 60m sync ${musicPath} cloud:Music
  '';
in {
  options.modules.desktop.feats.rclone = {
    enable = mkEnableOption "rclone support";
    config = mkOption { type = types.path; };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ sync-music ];
      home.file.".config/rclone/rclone.conf".source = cfg.config;
    };
  };
}

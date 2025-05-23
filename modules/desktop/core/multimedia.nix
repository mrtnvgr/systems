{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ feh mpv ffmpeg imagemagick sox ];
  };
}

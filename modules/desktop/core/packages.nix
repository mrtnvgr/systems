{ pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xdg-utils

      # Media capturing
      wl-clipboard
      wl-screenrec

      # Media conversion
      ffmpeg
    ];
  };
}

{ pkgs, lib, config, ... }:
let
  screenshot-select = pkgs.writeScriptBin "screenshot-select" "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\"";
  screenshot-full = pkgs.writeScriptBin "screenshot-full" "${pkgs.grim}/bin/grim";

  cfg = config.modules.desktop;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Viewers
      feh mpv

      # Converters / Editors / FX
      ffmpeg imagemagick sox rubberband

      # Screenshot / Video capturing
      screenshot-select screenshot-full
      obs-studio-plus
    ];
  };
}

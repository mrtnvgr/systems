{ pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ feh mpv ];
  };
}

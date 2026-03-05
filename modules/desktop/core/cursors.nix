{ config, pkgs, user, lib, ... }: let
  cfg = config.modules.desktop;
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    home.pointerCursor = {
      package = pkgs.catppuccin-cursors.macchiatoPink;
      name = "catppuccin-macchiato-pink-cursors";

      size = 24;

      x11.enable = true;
      gtk.enable = true;
    };
  };
}

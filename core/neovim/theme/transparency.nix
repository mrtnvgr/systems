{ config, user, lib, ... }: let
  opacity = config.modules.desktop.theme.opacity;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf (opacity != 1.0) {
    colorschemes.catppuccin.settings = {
      transparent_background = true;
      float.transparent = true;
    };
  };
}

{ config, user, lib, ... }: let
  opacity = config.modules.desktop.theme.opacity;
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf (cfg.enable && (opacity != 1.0)) {
    colorschemes.catppuccin.settings = {
      transparent_background = true;
      float.transparent = true;
    };
  };
}

{ config, user, lib, ... }: let
  isCatppuccin = config.colorScheme.slug == "catppuccin";
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf isCatppuccin {
    colorschemes.catppuccin.enable = true;
  };
}

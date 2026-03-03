{ config, lib, user, ... }: {
  imports = [
    ./transparency.nix
    ./overrides.nix
  ];

  home-manager.users.${user}.programs.nixvim = lib.mkIf config.modules.desktop.apps.neovim.enable {
    colorschemes.catppuccin.enable = true;
  };
}

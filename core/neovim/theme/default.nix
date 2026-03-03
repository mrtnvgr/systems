{ user, ... }: {
  imports = [
    ./transparency.nix

    ./overrides.nix
  ];

  home-manager.users.${user}.programs.nixvim = {
    colorschemes.catppuccin.enable = true;
  };
}

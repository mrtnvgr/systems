{ inputs, lib, colorschemes, ... }: {
  imports = [ inputs.nix-colors.homeManagerModules.default ];

  colorScheme = lib.mkDefault colorschemes.catppuccin;
}

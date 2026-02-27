{ ... }: {
  imports = [
    ./lsp

    ./treesitter.nix
    ./telescope.nix
    ./flash.nix
    ./lualine.nix
    ./gitsigns.nix
    ./completion.nix
    ./autopairs.nix
    ./lastplace.nix
    ./oil.nix
    ./todo.nix
    ./colorizer.nix
  ];
}

{ ... }: {
  imports = [
    ./lsp

    ./treesitter.nix
    ./telescope
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

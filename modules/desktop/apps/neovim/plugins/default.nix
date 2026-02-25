{ ... }: {
  imports = [
    ./lsp

    ./treesitter.nix
    ./telescope.nix
    ./spider.nix
    ./flash.nix
    ./lualine.nix
    ./gitsigns.nix
    ./autopairs.nix
    ./lastplace.nix
    ./colorizer.nix
    ./oil.nix
    ./todo.nix
  ];
}

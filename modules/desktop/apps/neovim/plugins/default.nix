{ ... }: {
  imports = [
    ./lsp

    ./treesitter.nix
    ./dressing.nix
    ./movements.nix
    ./ui.nix
    ./nix.nix
    ./misc.nix
    ./todo.nix
  ];
}

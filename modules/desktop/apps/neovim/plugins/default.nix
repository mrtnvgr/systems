{ ... }: {
  imports = [
    ./lsp

    ./treesitter.nix
    ./dressing.nix
    ./movements.nix
    ./codeium.nix
    ./ui.nix
    ./nix.nix
    ./misc.nix
  ];
}

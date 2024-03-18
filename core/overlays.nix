{ inputs, ... }: {
  nixpkgs.overlays = with inputs; [
    neovim-nightly.overlay
    mrtnvgr.overlay
  ];
}

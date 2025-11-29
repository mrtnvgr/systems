{ inputs, ... }: {
  nixpkgs.overlays = with inputs; [
    neovim-nightly.overlays.default
    mrtnvgr.outputs.overlays.default
  ];
}

{ inputs, ... }: {
  nixpkgs.overlays = with inputs; [
    mrtnvgr.outputs.overlays.default
  ];
}

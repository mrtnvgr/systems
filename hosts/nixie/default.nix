{ ... }: {
  imports = [
    # Personal base (base with secrets)
    ../thlix

    ./secrets/reaper.nix
    ./secrets/celeste.nix
  ];

  modules.desktop = {
    feats = {
      bluetooth.enable = true;
    };

    apps = {
      reaper.enable = true;
    };
  };
}

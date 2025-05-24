{ ... }: {
  imports = [
    # Personal base (base with secrets)
    ../thlix

    ./secrets/reaper.nix
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

{ ... }: {
  imports = [
    # Personal base (base with secrets)
    ../thlix

    ./secrets/reaper.nix
  ];

  modules.desktop = {
    feats = {
    };

    apps = {
      reaper.enable = true;
    };
  };
}

{ ... }: {
  imports = [
    # Personal base (base with secrets)
    ../thlix

    ./secrets/reaper.nix
  ];

  modules.desktop = {
    feats = {
      music = {
        enable = true;
        path = "/mnt/ssd/Music/sorted";
      };
    };

    apps = {
      reaper.enable = true;
    };
  };
}

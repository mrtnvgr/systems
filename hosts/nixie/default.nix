{ pkgs, user, ... }: {
  imports = [
    # Personal base (base with secrets)
    ../thlix

    ./m8sort.nix

    ./secrets/reaper.nix
    ./secrets/celeste.nix
  ];

  modules.desktop = {
    feats = {
      bluetooth.enable = true;
    };

    dev.flutter.enable = true;

    apps = {
      reaper.enable = true;

      renoise.enable = true;
      # Remove this line to use a demo version.
      renoise.releasePath = /home/${user}/.local/share/rns.tar.gz;
    };
  };
}

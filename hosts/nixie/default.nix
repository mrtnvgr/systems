{ pkgs, user, ... }: {
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

      renoise.enable = true;
      # Remove this line to use a demo version.
      renoise.releasePath = /home/${user}/.local/share/rns.tar.gz;
    };
  };
}

{ pkgs, user, ... }: {
  imports = [
    # Personal base (base with secrets)
    ../thlix

    ./m8sort.nix

    ./secrets/reaper.nix
    ./secrets/celeste.nix
  ];

  modules.desktop = {
    apps = {
      reaper.enable = true;

    apps = {
      renoise.enable = true;
      # Remove this line to use a demo version.
      renoise.releasePath = /home/${user}/.local/share/rns351.tar.gz;
    };

    games.xonotic.enable = true;

    audio = {
      rt.enable = true;

      plugins.enable = true;
      plugins.wine.enable = true;

      daws.reaper.enable = true;
    };
  };
}

{ pkgs, user, ... }: {
  imports = [
    # Personal base (base with secrets)
    ../thlix

    ./m8sort.nix

    ./secrets/reaper.nix
    ./secrets/celeste.nix
  ];

  modules.desktop = {
    # TODO: delete?
    dev.flutter.enable = false;

    games.xonotic.enable = true;

    audio = {
      rt.enable = true;

      plugins.enable = true;
      plugins.wine.enable = true;

      daws.reaper = {
        enable = true;

        templates.tracks."MIDI Track" = {
          record.enable = true;
          record.input = "<all_midi>";
          record.armOnSelect = true;
        };
      };

      daws.renoise.enable = true;
      # Remove this line to use a demo version.
      daws.renoise.releasePath = /home/${user}/.local/share/rns351.tar.gz;
    };
  };

  modules.generic.services.docker.enable = true;
}

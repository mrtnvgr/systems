{ pkgs, config, lib, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
in {
  imports = [
    ./colors.nix
  ];

  home-manager.users.${user} = lib.mkIf cfg.enable {
    programs.reanix = {
      themes.reapertips = {
        enable = true;

        undimmed = true;
        colored_track_names = true;
      };

      config.theme.path = "<reapertips>";
    };

    # Dark menus
    home.file.".config/REAPER/libSwell-user.colortheme".source = ./libSwell-user.colortheme;

    # Reaper MIDI notes colormap
    home.file.".config/REAPER/Data/color_maps/default.png".source = pkgs.fetchurl {
      url = "https://i.imgur.com/Ca0JhRF.png";
      hash = "sha256-FSANQn2V4TjYUvNr4UV1qUhOSeUkT+gsd1pPj4214GY=";
    };
  };
}

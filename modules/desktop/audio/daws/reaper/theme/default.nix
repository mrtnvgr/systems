{ pkgs, config, user, ... }: let
  inherit (config.colorScheme) palette;

  colors = with palette; [
    red
    green
    yellow
    blue
    orange
    violet
    lavender
    pink
    sapphire
    sky
    teal
  ];
in {
  home-manager.users.${user} = {
    programs.reanix.colors = colors;

    programs.reanix.config."reaper.ini" = /* dosini */ ''
      ; Selected theme
      [reaper]
      lastthemefn5=/home/${user}/.config/REAPER/ColorThemes/Reapertips.ReaperTheme
    '';

    home.file.".config/REAPER/ColorThemes/Reapertips.ReaperThemeZip".source = pkgs.fetchurl {
      url = "https://github.com/mrtnvgr/reapertips-theme/raw/refs/heads/v1.90/02_Theme/Reapertips%20Theme.ReaperThemeZip";
      hash = "sha256-GHH9fufbzeKUUxoEvk3tbLgk2YHlias5/dmSX2sf6MY=";
    };

    # Required fonts for Reapertips theme
    home.packages = with pkgs; [ fira-sans roboto ];

    # Dark menus
    home.file.".config/REAPER/libSwell-user.colortheme".source = ./libSwell-user.colortheme;

    # Reaper MIDI notes colormap
    home.file.".config/REAPER/Data/color_maps/default.png".source = pkgs.fetchurl {
      url = "https://i.imgur.com/Ca0JhRF.png";
      hash = "sha256-FSANQn2V4TjYUvNr4UV1qUhOSeUkT+gsd1pPj4214GY=";
    };
  };
}

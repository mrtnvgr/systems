{ inputs, pkgs, lib, config, user, ... }: let
  mrtnvgr-lib = inputs.mrtnvgr.lib { inherit pkgs; };

  cfg = config.modules.desktop.audio.daws.reaper;

  # inherit (config.colorScheme) palette;
  colors = [
    "#906BFA"
    "#D86BFA"
    "#EE65CB"
    "#F36889"
    "#F3845D"
    "#F3D161"
    "#54D362"
    "#1EDFAD"
    "#00B6F1"
    "#ABCDFF"
    "#D1E4FF"
  ];
  bgrColors = map (x: lib.removePrefix "#" x) (map mrtnvgr-lib.colors.hex.flip colors);
  custColors = lib.concatStrings (map (x: "${x}00") bgrColors);
in {
  config = lib.mkIf cfg.enable {
    modules.desktop.audio.daws.reaper.config."reaper.ini" = /* dosini */ ''
      ; Selected theme
      [reaper]
      lastthemefn5=/home/${user}/.config/REAPER/ColorThemes/Reapertips.ReaperTheme

      ; Custom colors
      [reaper]
      custcolors=${custColors}
    '';

    home-manager.users.${user} = {
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
  };
}

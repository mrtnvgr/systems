{ pkgs, config, lib, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
in {
  imports = [
    ./colors.nix
  ];

  home-manager.users.${user} = lib.mkIf cfg.enable {
    programs.reanix.extraConfig = {
      "reaper.ini" = /* dosini */ ''
        ; Selected theme
        [reaper]
        lastthemefn5=/home/${user}/.config/REAPER/ColorThemes/Reapertips.ReaperTheme
      '';

      "reaper-themeconfig.ini" = /* dosini */ ''
        ; Darken the theme
        [Reapertips]
        __coloradjust=1.00000000 -25 -25 51 256 192
      '';
    };

    home.file.".config/REAPER/ColorThemes/Reapertips.ReaperThemeZip".source = pkgs.reapertips-dark.override {
      undimmed = true;
      colored_track_names = true;
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

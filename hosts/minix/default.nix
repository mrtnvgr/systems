{ colorschemes, pkgs, ... }: {
  colorScheme = colorschemes.catppuccin;

  modules.desktop = {
    enable = true;

    theme = {
      rice = "hyprpop";

      # Double-width glyphs:
      # No prefix - will overlap with other symbols
      # "... Mono" - half-sized
      # "... Propo" - grid is destroyed, but big symbols
      # Source: https://github.com/ryanoasis/nerd-fonts/discussions/1103#discussioncomment-4852120
      # FIXME: Propo doesn't work with foot terminal! (Propo == "No prefix")
      font = {
        name = "CaskaydiaMono Nerd Font Propo";
        package = pkgs.cascadia-mono-nerd-font;
      };

      # font = {
      #   name = "Cozette";
      #   package = pkgs.cozette;
      # };

      opacity = 0.8;

      wallpaper = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/73/wallhaven-73qz6y.png";
        hash = "sha256-CGZqwT976V8odi8lNThbSTIQFbhI9twC4h1jWPG06zM=";
      };
    };

    feats = {
      midi.enable = true;
    };

    apps = {
      neovim.enable = true;
      firefox.enable = true;
    };

    dev = {
      rust.enable = true;
      python.enable = true;
    };
  };

  system.stateVersion = "23.05";
}

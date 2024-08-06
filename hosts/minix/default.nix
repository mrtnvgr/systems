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

      wallpapers = with pkgs; [
        # "${colorScheme.palette.background}"

        (fetchurl {
          url = "https://w.wallhaven.cc/full/72/wallhaven-72weyy.jpg";
          hash = "sha256-H9VpfpdOQzfzHkKE1HzjbfUdBLqGU0+5wuWzxQBB0cc=";
        })

        # (fetchurl {
        #   url = "https://w.wallhaven.cc/full/m3/wallhaven-m3zrmy.png";
        #   hash = "sha256-BNsKALFBm9Ukb6j62fap3n/O0bHlyYFj0ic5qnfdbnI=";
        # })

        (fetchurl {
          url = "https://w.wallhaven.cc/full/2y/wallhaven-2yw9w9.png";
          hash = "sha256-ieVRCXZszemw8Ai1nLXrYDm/gLrJGY4yeZntEOCL/GM=";
        })

        (fetchurl {
          url = "https://w.wallhaven.cc/full/p9/wallhaven-p9l9r9.png";
          hash = "sha256-yYt4bvU1K/F2xqGzgExckzzbcYPtXFyNPnP/TP5H3dI=";
        })

        (fetchurl {
          url = "https://w.wallhaven.cc/full/73/wallhaven-73qz6y.png";
          hash = "sha256-CGZqwT976V8odi8lNThbSTIQFbhI9twC4h1jWPG06zM=";
        })
      ];
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

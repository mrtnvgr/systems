{ config, user, ... }:
let
  inherit (config.colorScheme) palette;
  opacity = config.modules.desktop.theme.opacity;
in {
  home-manager.users.${user}.programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;

      settings = {
        transparent_background = !(isNull opacity || opacity == 1.0);

        color_overrides.mocha = {
          base = "#${palette.background}";
          mantle = "#${palette.darkness}";
          crust = "#${palette.void}";

          surface0 = "#${palette.gray}";
          surface1 = "#${palette.gray2}";
          surface2 = "#${palette.gray3}";
          overlay0 = "#${palette.gray4}";
          overlay1 = "#${palette.gray5}";
          overlay2 = "#${palette.gray6}";
          subtext0 = "#${palette.gray7}";
          subtext1 = "#${palette.gray8}";

          text = "#${palette.text}";

          red = "#${palette.red}";
          green = "#${palette.green}";
          yellow = "#${palette.yellow}";
          blue = "#${palette.blue}";

          peach = "#${palette.orange}";

          mauve = "#${palette.violet}";
          lavender = "#${palette.lavender}";

          pink = "#${palette.pink}";
          maroon = "#${palette.lipstick}";
          flamingo = "#${palette.skin}";
          rosewater = "#${palette.fawn}";

          sapphire = "#${palette.sapphire}";
          sky = "#${palette.sky}";
          teal = "#${palette.teal}";
        };
      };
    };

    highlight.NormalFloat.bg = "NONE";
    highlight.Pmenu.bg = "NONE";
  };
}

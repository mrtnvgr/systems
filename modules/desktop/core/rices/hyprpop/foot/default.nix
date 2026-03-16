{ lib, config, user, ... }: let
  theme = config.modules.desktop.theme;
  inherit (theme.colorscheme) palette;
in {
  home-manager.users.${user} = lib.mkIf (theme.rice == "hyprpop") {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "${theme.font.name}:size=13";
          pad = "10x10";
          term = "xterm-256color";
        };

        mouse.hide-when-typing = "yes";

        colors-dark.alpha = theme.opacity;

        colors-dark = {
          background = palette.background;
          foreground = palette.text;
          cursor = "${palette.background} ${palette.text}";

          inherit (palette) regular0;
          inherit (palette) regular1;
          inherit (palette) regular2;
          inherit (palette) regular3;
          inherit (palette) regular4;
          inherit (palette) regular5;
          inherit (palette) regular6;
          inherit (palette) regular7;

          inherit (palette) bright0;
          inherit (palette) bright1;
          inherit (palette) bright2;
          inherit (palette) bright3;
          inherit (palette) bright4;
          inherit (palette) bright5;
          inherit (palette) bright6;
          inherit (palette) bright7;
        };
      };
    };
  };
}

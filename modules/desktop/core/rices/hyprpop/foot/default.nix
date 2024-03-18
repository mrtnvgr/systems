{ pkgs, lib, config, user, ... }:
let
  inherit (config.colorScheme) palette;
  inherit (lib) mkIf;
  theme = config.modules.desktop.theme;
in {
  config = mkIf (theme.rice == "hyprpop") {
    home-manager.users.${user} = {
      programs.foot = {
        enable = true;
        settings = {
          main = {
            font = "${theme.font.name}:size=13";
            pad = "10x10";
            term = "xterm-256color";
          };

          cursor.color = "${palette.background} ${palette.text}";
          mouse.hide-when-typing = "yes";

          colors.alpha = theme.opacity;

          # note: modified to personal liking
          colors = {
            background = "${palette.background}";
            foreground = "${palette.text}";

            regular0 = "${palette.background}";
            regular1 = "${palette.red}";
            regular2 = "${palette.green}";
            regular3 = "${palette.yellow}";
            regular4 = "${palette.blue}";
            regular5 = "${palette.violet}";
            regular6 = "${palette.lavender}";
            regular7 = "${palette.text}";

            bright0 = "${palette.gray2}";
            bright1 = "${palette.red}";
            bright2 = "${palette.green}";
            bright3 = "${palette.yellow}";
            bright4 = "${palette.blue}";
            bright5 = "${palette.violet}";
            bright6 = "${palette.lavender}";
            bright7 = "${palette.text}";
          };
        };
      };
    };
  };
}

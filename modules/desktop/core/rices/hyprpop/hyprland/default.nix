{ lib, config, user, ... }:
let
  inherit (lib) mkIf fileContents;
  inherit (config.colorScheme) palette;

  theme = config.modules.desktop.theme;
in {
  imports = [
    ./portal.nix
    ./polkit.nix
    ./wallpaper.nix
  ];

  config = mkIf (theme.rice == "hyprpop") {
    home-manager.users.${user} = {
      wayland.windowManager.hyprland = {
        enable = true;

        settings = with palette; {
          general = {
            "col.active_border" = "rgb(${blue})";
            "col.inactive_border" = "rgb(${gray2})";
          };

          decoration."col.shadow" = "rgb(${void})";
          misc."background_color" = "rgb(${background})";
        };

        extraConfig = fileContents ./hyprland.conf;
      };
    };
  };
}

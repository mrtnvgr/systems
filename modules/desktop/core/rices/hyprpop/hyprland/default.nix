{ inputs, pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf fileContents;
  inherit (config.colorScheme) palette;

  hyprland-nightly = inputs.hyprland.packages.${pkgs.system}.hyprland;
  theme = config.modules.desktop.theme;
in {
  imports = [
    ./portal.nix
    ./wallpaper.nix
  ];

  config = mkIf (theme.rice == "hyprpop") {
    home-manager.users.${user} = {
      wayland.windowManager.hyprland = {
        enable = true;
        package = hyprland-nightly;

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

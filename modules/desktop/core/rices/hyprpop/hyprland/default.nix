{ pkgs, lib, config, user, ... }: let
  theme = config.modules.desktop.theme;
  inherit (theme.colorscheme) palette;
in {
  imports = [
    ./polkit.nix
    ./wallpaper.nix
  ];

  config = lib.mkIf (theme.rice == "hyprpop") {
    home-manager.users.${user} = {
      wayland.windowManager.hyprland = {
        enable = true;

        settings = with palette; {
          general = {
            "col.active_border" = "rgb(${blue})";
            "col.inactive_border" = "rgb(${gray2})";
          };

          misc."background_color" = "rgb(${background})";
        };

        extraConfig = lib.fileContents ./hyprland.conf;
      };

      xdg.portal = {
        extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
        configPackages = [ pkgs.hyprland ];
      };
    };
  };
}

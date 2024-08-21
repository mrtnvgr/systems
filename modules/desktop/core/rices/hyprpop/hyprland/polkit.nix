{ pkgs, lib, config, user, ... }: let
  inherit (lib) mkIf;
  theme = config.modules.desktop.theme;
in {
  config = mkIf (theme.rice == "hyprpop") {
    home-manager.users.${user} = {
      wayland.windowManager.hyprland.extraConfig = ''
        exec-once=${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
      '';
    };

    security.polkit.enable = true;
  };
}

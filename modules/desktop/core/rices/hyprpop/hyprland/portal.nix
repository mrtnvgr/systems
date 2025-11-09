{ pkgs, lib, config, user, ... }: let
  inherit (lib) mkIf;
  theme = config.modules.desktop.theme;
in {
  config = mkIf (theme.rice == "hyprpop") {
    home-manager.users.${user} = {
      systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
    };

    xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };
}

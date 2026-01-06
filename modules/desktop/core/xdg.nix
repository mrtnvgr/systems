{ pkgs, config, lib, user, ... }: {
  config = lib.mkIf config.modules.desktop.enable {
    home-manager.users.${user} = {
      xdg.enable = true;

      xdg.userDirs = rec {
        enable = true;

        desktop = "/home/${user}";
        documents = "${desktop}/.local/documents";
      };

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };
    };
  };
}

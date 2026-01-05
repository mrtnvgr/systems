{ pkgs, config, lib, user, ... }: {
  config = lib.mkIf config.modules.desktop.enable {
    home-manager.users.${user} = {
      xdg.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };
    };

    environment.sessionVariables = {
      "XDG_DOCUMENTS_DIR" = "/home/${user}/.local/documents";
    };
  };
}

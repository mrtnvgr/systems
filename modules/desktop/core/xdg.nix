{ pkgs, config, lib, user, ... }: {
  config = lib.mkIf config.modules.desktop.enable {
    home-manager.users.${user} = {
      xdg.enable = true;
    };

    environment.sessionVariables = {
      "XDG_DOCUMENTS_DIR" = "/home/${user}/.local/documents";
    };

    xdg.portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}

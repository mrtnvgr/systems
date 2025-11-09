{ pkgs, config, lib, ... }: {
  config = lib.mkIf config.modules.desktop.enable {
    xdg.portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}

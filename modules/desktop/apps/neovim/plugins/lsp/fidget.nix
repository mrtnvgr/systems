{ lib, config, user, ... }: let
  isDev = config.modules.desktop.dev.enable;
  neovimEnabled = config.modules.desktop.apps.neovim.enable;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf (neovimEnabled && isDev) {
    plugins.fidget = {
      enable = true;
      settings.notification.window.winblend = 0;
    };
  };
}

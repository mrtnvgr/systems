{ config, lib, user, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${user}.programs.nixvim = {
      plugins.blink-cmp = {
        enable = true;

        settings = {
          keymap.preset = "super-tab";
          completion.documentation.auto_show = true;
        };
      };
    };
  };
}

{ lib, config, user, ... }: let
  desk = config.modules.desktop;
  enabled = desk.apps.neovim.enable && desk.dev.rust.enable;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf enabled {
    plugins.blink-cmp = {
      enable = true;

      settings = {
        keymap.preset = "super-tab";
        completion.documentation.auto_show = true;
      };
    };
  };
}

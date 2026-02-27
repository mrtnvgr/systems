{ lib, config, user, ... }: {
  home-manager.users.${user}.programs.nixvim = lib.mkIf config.modules.desktop.apps.neovim.enable {
    plugins.blink-cmp = {
      enable = true;

      settings = {
        keymap.preset = "super-tab";
        completion.documentation.auto_show = true;
      };
    };
  };
}

{ config, user, lib, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    plugins.spider = {
      enable = true;
      keymaps.motions = lib.genAttrs ["b" "e" "ge" "w"] lib.id;
    };
  };
}

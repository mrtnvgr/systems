{ config, user, lib, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    plugins.flash.enable = true;

    keymaps = [{
      key = "s";
      mode = [ "n" "x" "o" ];
      action.__raw = ''function() require("flash").jump() end'';
    }];
  };
}

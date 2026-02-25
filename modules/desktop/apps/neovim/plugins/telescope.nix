{ config, lib, user, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    plugins.telescope = {
      enable = true;
      keymaps."<leader>ff" = "find_files";
    };

    plugins.web-devicons.enable = true;
  };
}

{ inputs, config, lib, user, pkgs, ... }: let
  cfg = config.modules.desktop.apps.neovim;

  actions-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "actions.nvim";
    src = inputs.mrtnvgr-actions;
  };
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    extraPlugins = [ actions-nvim ];
    extraConfigLua = ''
      local actions = require("actions");
      actions.setup({ actions = actions.stock_actions })
    '';

    plugins.telescope = {
      enabledExtensions = [ "actions" ];
      keymaps."?" = "actions action_list";
    };
  };
}

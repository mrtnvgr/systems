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
      require("actions").setup()
      MiniPick.registry.action_list = require("actions.pickers").action_list
    '';

    keymaps = [
      # note: use just `MiniPick.registry.action_list` when plugin setup will be before the `keymaps` stage
      { mode = "n"; key = "?"; action.__raw = ''require("actions.pickers").action_list''; }
    ];
  };
}

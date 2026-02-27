{ config, lib, user, pkgs, ... }: let
  cfg = config.modules.desktop.apps.neovim;

  actions-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "actions.nvim";
    src = /home/user/actions.nvim;
  };
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    extraPlugins = [ actions-nvim ];
    extraConfigLua = ''
      require("actions").setup({
        actions = {
          -- TODO: include real actions, modules.desktop.actions."..." = "..."
          ["Format LSP code"] = function() vim.lsp.buf.format() end,
          ["Rename symbol"] = function() vim.lsp.buf.rename() end,
          ["Go to definition"] = function() vim.lsp.buf.definition() end,
        },
      })
    '';

    plugins.telescope = {
      enabledExtensions = [ "actions" ];
      keymaps."?" = "actions action_list";
    };
  };
}

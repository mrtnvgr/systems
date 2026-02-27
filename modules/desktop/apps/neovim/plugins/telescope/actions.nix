{ config, lib, user, pkgs, ... }: let
  cfg = config.modules.desktop.apps.neovim;

  # TODO: package in nixpkgs, make a PR to nixvim
  actions-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "actions.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "mrtnvgr";
      repo = "actions.nvim";
      rev = "64e3fc4c73cf4c67ea52631a61428f53964a9fd2";
      hash = "sha256-652SmMElnGL8BZ0hP0EyRt59xPoPTf9djva4Lkcygc0=";
    };
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

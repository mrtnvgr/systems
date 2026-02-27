{ config, lib, user, pkgs, ... }: let
  cfg = config.modules.desktop.apps.neovim;

  actions-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "actions.nvim";
    src = /home/user/actions.nvim;
  };
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ actions-nvim ];
      extraConfigLua = ''
        require("actions").setup({
          actions = {
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

    home.file.".config/nvim/init_actions_window.lua".text = ''
      vim.api.nvim_create_autocmd("BufLeave", {
        callback = function(opts)
          local filetype = vim.api.nvim_buf_get_option(opts.buf, "filetype")
          if filetype == "TelescopePrompt" then
            vim.schedule(function() vim.cmd("quit") end)
          end
        end,
      })

      require("telescope").extensions.actions.action_list()
    '';
  };
}

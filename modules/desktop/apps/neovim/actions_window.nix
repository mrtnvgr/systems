{ config, lib, user, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
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

{ config, lib, user, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    diagnostic.settings.signs = true;

    extraConfigLua = ''
      local signs = { Error = "😡", Warn = "🤓", Hint = "🤓", Info = "🤓" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    '';
  };
}

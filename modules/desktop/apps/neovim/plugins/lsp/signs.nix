{ lib, config, user, ... }: let
  isDev = config.modules.desktop.dev.enable;
  neovimEnabled = config.modules.desktop.apps.neovim.enable;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf (neovimEnabled && isDev) {
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

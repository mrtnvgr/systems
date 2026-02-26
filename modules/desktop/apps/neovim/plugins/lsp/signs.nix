{ lib, config, user, ... }: let
  desk = config.modules.desktop;
  enabled = desk.apps.neovim.enable && desk.dev.rust.enable;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf enabled {
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

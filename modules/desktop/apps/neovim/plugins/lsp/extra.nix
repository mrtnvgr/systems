{ config, lib, user, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim.extraConfigLua = mkIf cfg.enable ''
    vim.diagnostic.config({
      virtual_text = false,
      update_in_insert = true,
      severity_sort = true,
      signs = true,

      float = {
        style = "minimal",
        border = "${cfg.border}",
        source = "if_many",
        focusable = false,
        header = "",
        prefix = "",
        suffix = "",
      },
    })

    local signs = { Error = "😡", Warn = "🤓", Hint = "🤓", Info = "🤓" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover,
      { border = "${cfg.border}" }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help,
      { border = "${cfg.border}" }
    )

    vim.lsp.set_log_level("off")
  '';
}

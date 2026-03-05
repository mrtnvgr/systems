{ config, user, lib, ... }: let
  cfg = config.modules.desktop.apps.neovim;

  inherit (config.modules.desktop.theme.colorscheme) palette;
  mkColor = color: { fg = "#${color}"; };
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    plugins.todo-comments.enable = true;

    highlightOverride = with palette; {
      "DiagnosticInfo" = mkColor blue;
      "DiagnosticHint" = mkColor purple;
      "DiagnosticWarn" = mkColor yellow;
      "DiagnosticError" = mkColor red;

      "TODO".link = "DiagnosticInfo";
    };
  };
}

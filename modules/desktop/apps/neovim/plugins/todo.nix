{ config, user, lib, ... }: let
  cfg = config.modules.desktop.apps.neovim;

  inherit (config.colorScheme) palette;
  mkColor = color: { fg = "#${color}"; };
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    plugins.todo-comments.enable = true;

    highlightOverride = with palette; {
      "DiagnosticInfo" = mkColor sky;
      "DiagnosticHint" = mkColor violet;
      "DiagnosticWarn" = mkColor yellow;
      "DiagnosticError" = mkColor red;

      "TODO".link = "DiagnosticInfo";
    };
  };
}

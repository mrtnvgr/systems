{ lib, config, user, ... }: let
  isDev = config.modules.desktop.dev.enable;
  neovimEnabled = config.modules.desktop.apps.neovim.enable;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf (neovimEnabled && isDev) {
    diagnostic.settings = {
      severity_sort = true;

      signs = {
        text."ERROR" = "😡";
        text."WARN" = "🤓";
        text."HINT" = "🤓";
        text."INFO" = "🤓";
      };

      # Update diagnostics in insert mode for instant feedback
      update_in_insert = true;
    };
  };
}

{ config, lib, user, ... }: let
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    plugins.telescope = {
      enable = true;

      keymaps."<leader>f" = "find_files";
      keymaps."<leader>g" = "live_grep";

      # TODO: fix: use ":" in prompt char
      # settings.defaults.selection_caret = ": ";

      # It is possible to enter normal mode in telescope.
      # Since its rarely used, but now prompt closing takes 2 esc presses, let's disable it
      settings.defaults.mappings.i."<Esc>".__raw = ''require("telescope.actions").close'';

      # Faster search engine
      extensions.fzy-native.enable = true;
    };

    plugins.web-devicons.enable = true;
  };
}

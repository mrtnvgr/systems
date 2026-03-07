{ lib, config, user, ... }: {
  home-manager.users.${user}.programs.nixvim = lib.mkIf config.modules.desktop.apps.neovim.enable {
    plugins.blink-cmp = {
      enable = true;

      settings = {
        keymap.preset = "super-tab";
        completion.documentation.auto_show = true;
      };
    };

    plugins.blink-emoji.enable = true;

    plugins.blink-cmp.settings.sources.providers = {
      emoji = {
        module = "blink-emoji";
        name = "Emoji";
        score_offset = 15;
        opts.insert = true;
      };
    };

    plugins.blink-cmp.settings.sources.default = [
      "lsp"
      "path"
      "snippets"
      "buffer"
      "emoji"
    ];

    plugins.friendly-snippets.enable = true;
  };
}

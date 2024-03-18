{ pkgs, config, lib, user, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim = mkIf cfg.enable {
    extraPlugins = with pkgs.vimPlugins; [ dressing-nvim ];

    extraConfigLua = ''
      require("dressing").setup({
        input = { border = "${cfg.border}" },
        select = {
          backend = { "telescope", "nui" },
          nui = {
            border = { style = "${cfg.border}" },
          },
          builtin = {
            border = "${cfg.border}",
          },
        },
      })
    '';
  };
}

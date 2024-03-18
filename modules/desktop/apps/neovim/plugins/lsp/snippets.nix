{ pkgs, config, lib, user, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim = mkIf cfg.enable {
    plugins.luasnip.enable = true;
    extraPlugins = with pkgs.vimPlugins; [ friendly-snippets ];
  };
}

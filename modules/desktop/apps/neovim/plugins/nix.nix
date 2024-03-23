{ config, lib, user, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim.plugins = mkIf cfg.enable {
    hmts.enable = true;

    lsp.servers.nixd.enable = true;
  };
}

{ config, lib, user, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim.plugins = mkIf cfg.enable {
    hmts.enable = true;

    # TODO: https://github.com/nix-community/nixd/issues/357
    # lsp.servers.nixd.enable = true;
  };
}

{ config, lib, user, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim.plugins = mkIf cfg.enable {
    treesitter = {
      enable = true;
      settings.indent.enable = true;
      nixvimInjections = true;
    };
  };
}

{ config, lib, user, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.apps.neovim;
in {
  home-manager.users.${user}.programs.nixvim.plugins = mkIf cfg.enable {
    gitsigns.enable = true;
    nvim-autopairs.enable = true;
    lastplace.enable = true;
    nix.enable = true;

    colorizer = {
      enable = true;
      settings.user_default_options.names = false;
    };

    oil.enable = true;
  };
}

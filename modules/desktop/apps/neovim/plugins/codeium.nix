{ config, lib, user, ... }:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.modules.desktop.apps.neovim;
in {
  options.modules.desktop.apps.neovim = {
    codeiumConfig = mkOption {
      type = with types; nullOr path;
      default = null;
    };
  };

  config = mkIf (cfg.codeiumConfig != null) {
    home-manager.users.${user} = {
      programs.nixvim.plugins.codeium-nvim.enable = true;
      home.file.".cache/nvim/codeium/config.json".source = cfg.codeiumConfig;
    };
  };
}

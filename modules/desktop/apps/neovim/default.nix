{ pkgs, lib, config, user, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.desktop.apps.neovim;
in {
  options.modules.desktop.apps.neovim = {
    enable = mkEnableOption "neovim";

    border = mkOption {
      type = types.str;
      default = "single";
    };
  };

  imports = [
    ./plugins
  ];
}

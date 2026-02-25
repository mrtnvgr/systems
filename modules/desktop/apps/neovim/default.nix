{ lib, ... }: let
  inherit (lib) mkEnableOption mkOption types;
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

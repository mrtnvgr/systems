{ pkgs, lib, config, ... }:
let
  cfg = config.modules.desktop;
in {
  options.modules.desktop.theme.font = {
    name = lib.mkOption { type = lib.types.str; };
    package = lib.mkOption { type = lib.types.package; };
  };

  config = lib.mkIf cfg.enable {
    fonts.enableDefaultPackages = true;

    fonts.packages = [
      cfg.theme.font.package
      pkgs.corefonts
    ];
  };
}

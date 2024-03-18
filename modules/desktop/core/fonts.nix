{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkOption types;

  cfg = config.modules.desktop;
  font = cfg.theme.font;
in {
  options.modules.desktop.theme.font = {
    name = mkOption { type = types.str; };
    package = mkOption { type = types.package; };
  };

  config = mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        corefonts
        dejavu_fonts
        font.package
      ];
    };
  };
}

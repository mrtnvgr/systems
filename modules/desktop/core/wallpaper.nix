{ lib, ... }: let
  inherit (lib) mkOption types;
in {
  options.modules.desktop.theme.wallpaper = mkOption {
    type = with types; nullOr package;
    default = null;
  };
}

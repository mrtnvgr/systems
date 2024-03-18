{ lib, ... }:
let
  inherit (lib) mkOption types;
  rices = [ "hyprpop" ];
in {
  options.modules.desktop.theme = {
    rice = mkOption {
      type = with types; nullOr (enum rices);
      default = null;
    };

    opacity = mkOption {
      type = with types; nullOr (numbers.between 0.0 1.0);
      default = null;
    };
  };

  imports = map (rice: ./${rice}) rices;
}

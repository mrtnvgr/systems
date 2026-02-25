{ lib, ... }:
let
  inherit (lib) mkOption types;
  rices = [ "hyprpop" ];
in {
  options.modules.desktop.theme = {
    rice = mkOption {
      type = types.nullOr (types.enum rices);
      default = null;
    };

    opacity = mkOption {
      type = types.numbers.between 0.0 1.0;
      default = 1.0;
    };
  };

  imports = map (rice: ./${rice}) rices;
}

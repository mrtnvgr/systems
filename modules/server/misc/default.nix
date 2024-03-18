{ lib, config, ... }:
let
  inherit (lib) mkOption mkEnableOption types;
in {
  options.modules.server.misc.enable = mkEnableOption "other services";

  imports = [
    ./vkreborn
  ];
}

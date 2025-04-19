{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in {
  options.modules.server.misc.enable = mkEnableOption "other services";

  imports = [
    ./torrserver
  ];
}

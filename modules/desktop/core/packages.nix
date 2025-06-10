{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop;

  m8sort = pkgs.writeShellScriptBin "m8sort" ''
    fatsort -X Songs "$1"
    fatsort -X Bundles "$1"
    fatsort -t -D Songs "$1"
    fatsort -t -D Bundles "$1"
  '';
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xdg-utils

      xxd
      colordiff

      m8sort
    ];
  };
}

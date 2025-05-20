{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop;

  m8sort = pkgs.writeShellScriptBin "m8sort" ''
    fatsort -x Songs "$1"
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

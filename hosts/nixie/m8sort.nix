{ pkgs, ... }: let
  m8sort = pkgs.writeShellScriptBin "m8sort" ''
    ${pkgs.fatsort} -X Songs "$1"
    ${pkgs.fatsort} -X Bundles "$1"
    ${pkgs.fatsort} -t -D Songs "$1"
    ${pkgs.fatsort} -t -D Bundles "$1"
  '';
in {
  environment.systemPackages = [ m8sort ];
}

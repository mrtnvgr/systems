{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in {
  options.modules.server = {
    enable = mkEnableOption "server profile";
  };

  imports = [
    ./network.nix
    ./bloat.nix
	./fail2ban.nix
  ];
}

{ lib, ... }:
let
  inherit (lib) types mkEnableOption mkOption;
in {
  options.modules.server = {
    enable = mkEnableOption "server profile";
    sshKeys = mkOption { type = types.listOf types.str; };
  };

  imports = [
    ./sshd.nix
    ./network.nix
    ./bloat.nix
	./fail2ban.nix
  ];
}

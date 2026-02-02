{ lib, config, ... }:
let
  cfg = config.modules.server.misc.wireguard;

  keyOption = lib.mkOption { type = lib.types.singleLineStr; };

  userOption = lib.types.submodule {
    options = {
      keys.public = keyOption;
      keys.private = keyOption;
    };
  };

  wgPort = config.networking.wg-quick.interfaces.wg0.listenPort;
in {
  options.modules.server.misc.wireguard = {
    enable = lib.mkEnableOption "WireGuard";

    port = lib.mkOption {
      type = lib.types.port;
      default = 51820;
    };

    serverKeys = {
      public = keyOption;
      private = keyOption;
    };

    users = lib.mkOption {
      type = lib.types.attrsOf userOption;
      default = {};
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "expose port in firewall";
    };
  };

  imports = [
    ./tor.nix
  ];

  config = lib.mkIf cfg.enable {
    networking.wg-quick.interfaces.wg0 = {
      listenPort = cfg.port;

      address = [ "10.0.0.1/24" ];
      privateKey = cfg.serverKeys.private;

      # TODO: for file generation
      # lib.mapAttrsToList (name: x: x // { inherit name; }) cfg.users;

      peers = lib.imap1 (i: x: {
        publicKey = x.keys.public;
        allowedIPs = [ "10.0.0.${toString (i+1)}/32" ];
      }) (builtins.attrValues cfg.users);
    };

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall wgPort;

    # https://wiki.nixos.org/wiki/WireGuard#wg-quick_issues_with_NetworkManager
    # services.resolved.enable = true;
  };
}

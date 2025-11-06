{
  pkgs,
  lib,
  config,
  user,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf types;

  cfg = config.modules.desktop.games.xonotic;
in
{
  options.modules.desktop.games.xonotic = {
    enable = mkEnableOption "Xonotic";

    exposePorts = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.xonotic ];

    home-manager.users.${user} = {
      home.file.".xonotic/data/autoexec/mrtnvgr.cfg".source = ./config.cfg;
    };

    networking.firewall.allowedUDPPorts = mkIf cfg.exposePorts [ 26000 ];
  };
}

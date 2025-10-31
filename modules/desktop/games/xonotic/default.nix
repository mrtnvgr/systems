{ pkgs, lib, config, user, ... }: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.desktop.games.xonotic;
in {
  options.modules.desktop.games.xonotic = {
    enable = mkEnableOption "Xonotic";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.xonotic ];

    home-manager.users.${user} = {
      home.file.".xonotic/data/autoexec/mrtnvgr.cfg".source = ./config.cfg;
    };
  };
}

{ pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption types;

  defaultPackages = ps: with ps; [
    requests
    datetime
  ];

  cfg = config.modules.desktop.dev.python;
in
{
  options.modules.desktop.dev.python = {
    enable = mkEnableOption "python";
    packages = mkOption {
      type = with types; functionTo (listOf package);
      default = defaultPackages;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ (pkgs.python3.withPackages cfg.packages) ];
    };
  };
}

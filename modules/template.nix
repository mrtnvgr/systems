{ pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.SECTION.PROGRAM;
  inherit (config.colorScheme) palette;
in
{
  options.modules.SECTION.PROGRAM.enable = mkEnableOption "PROGRAM";
  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      # Home-manager configuration...
    };

    # System configuration...
  };
}

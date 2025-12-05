{ config, lib, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
  inherit (config.colorScheme) palette;

  colors = with palette; [
    red
    green
    yellow
    blue
    orange
    violet
    lavender
    pink
    sapphire
    sky
    teal
  ];
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    programs.reanix.colors = colors;
  };
}

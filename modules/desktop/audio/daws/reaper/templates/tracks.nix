{ config, lib, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    programs.reanix.templates.tracks = {
      "MIDI Track" = {
        record.enable = true;
        record.input = "<all_midi>";
        record.armOnSelect = true;
        key = "13 84"; # Ctrl + Shift + T
      };
    };
  };
}

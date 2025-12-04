{ inputs, lib, config, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    programs.reanix = {
      scripts.MKShaperStutter.source = "${inputs.reascripts}/Envelopes/cool_MK ShaperStutter.lua";

      extensions = {
        sws.enable = true;
        reaimgui.enable = true;
      };
    };
  };
}

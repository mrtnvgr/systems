{ inputs, lib, config, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    programs.reanix = {
      scripts.MKReSampler.source = "${inputs.reascripts}/Various/cool_MK ReSampler.lua";

      extensions = {
        sws.enable = true;
        reaimgui.enable = true;
      };
    };
  };
}

{ inputs, lib, config, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    programs.reanix = {
      scripts.MKSlicer.source = "${inputs.reascripts}/Items Editing/cool_MK Slicer.lua";

      extensions = {
        sws.enable = true;
        reaimgui.enable = true;
      };
    };
  };
}

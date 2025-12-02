{ inputs, lib, config, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
in {
  modules.desktop.audio.daws.reaper = lib.mkIf cfg.enable {
    scripts.MKSlicer.source = "${inputs.reascripts}/Items Editing/cool_MK Slicer.lua";

    extensions = {
      sws.enable = true;
      reaimgui.enable = true;
    };
  };
}

{ inputs, lib, config, user, ... }: let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.audio.daws.reaper;
in {
  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      # note: you must import them in the REAPER Actions menu
      # reaper-kb.ini: `SCR 4 0 RS{hash?} "{Script Name}" {relative_path}`
      # TODO: automate

      # MK Slicer, MK Shaper
      home.file.".config/REAPER/Scripts/cool/MKSlicer.lua".source = "${inputs.reascripts}/Items Editing/cool_MK Slicer.lua";
      home.file.".config/REAPER/Scripts/cool/MKShaper.lua".source = "${inputs.reascripts}/Envelopes/cool_MK ShaperStutter.lua";
    };
  };
}

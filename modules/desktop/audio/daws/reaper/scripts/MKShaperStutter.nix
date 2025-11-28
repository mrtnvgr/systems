{ inputs, lib, config, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
in {
  modules.desktop.audio.daws.reaper = lib.mkIf cfg.enable {
    scripts.MKShaperStutter.source = "${inputs.reascripts}/Envelopes/cool_MK ShaperStutter.lua";
  };
}

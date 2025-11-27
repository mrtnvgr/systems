{ inputs, lib, config, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
in {
  modules.desktop.audio.daws.reaper = lib.mkIf cfg.enable {
    scripts.ColorPalette = "${inputs.reascripts}/Various/rodilab_Color palette.lua";
    scriptMappings.ColorPalette = "47";
  };
}

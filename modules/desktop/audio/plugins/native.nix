{ inputs, pkgs, config, lib, user, ... }:
let
  mrtnvgr-lib = inputs.mrtnvgr.lib { inherit pkgs; };
  # TODO: create vst3 variants for most of these plugins
  # TODO: auburn-sounds-*

  synths = with pkgs; [
    surge-XT-vst3
    vitalium-vst3
    zynaddsubfx
    ripplerx
    # cardinal # fun, but too heavy
    chow-kick
    # oxefmsynth
    # time12, gate12... # TODO: wait for upstream merge # TODO: make -vst3 nurpkgs
  ];

  fx = with pkgs; [
    lsp-plugins-vst3
    airwin2rack
    TAL-plugins-vst2
    neural-amp-modeler-lv2
    dragonfly-reverb
    fire
    wolf-shaper
    molot-lite
    luftikus-vst2
    LUFSMeter-vst2
    chow-tape-model
    chow-centaur
    chow-phaser
  ];

  cfg = config.modules.desktop.audio.plugins;
  isAnyDawInstalled = config._internals.isAnyDawInstalled;
in
{
  options.modules.desktop.audio.plugins = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = isAnyDawInstalled;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = synths ++ fx;

    environment.sessionVariables = let
      make = format: mrtnvgr-lib.mkAudioPluginsPaths user format;
    in {
      VST3_PATH = make "vst3";
      VST_PATH = make "vst";
      CLAP_PATH = make "clap";
      LV2_PATH = make "lv2";
      LADSPA_PATH = make "ladspa";
    };
  };
}

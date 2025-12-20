{ inputs, pkgs, config, lib, user, ... }:
let
  mrtnvgr-lib = inputs.mrtnvgr.lib { inherit pkgs; };
  # TODO: create vst3 variants for most of these plugins

  synths = with pkgs; [
    surge-XT-vst3
    vitalium-vst3
    zynaddsubfx
    ripplerx
    # cardinal # fun, but too heavy
    chow-kick
    # oxefmsynth
    hamburger
    nils-k1v
    spectralsuite
    cstop
    socalabs-loser-ports
    socalabs-voc
    socalabs-mverb
    socalabs-wavetable
    socalabs-papu
    socalabs-piano
    socalabs-rp2a03
    socalabs-organ
    auburn-sounds-inner-pitch
    wildergarden-maim
    reevr
    filtr
    gate12
    time12
    sfizz-ui
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

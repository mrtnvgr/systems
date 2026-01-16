{ inputs, pkgs, config, lib, user, ... }:
let
  inherit (lib) mkOption types;

  mrtnvgr-lib = inputs.mrtnvgr.lib { inherit pkgs; };
  # TODO: create vst3 variants for most of these plugins

  synths = with pkgs; [
    surge-XT-vst3
    vital # vitalium-vst3
    ripplerx
    cardinal
    # chow-kick
    oxefmsynth
    sfizz-ui
    ob-xf
    odin2
  ];

  fx = with pkgs; [
    lsp-plugins-vst3
    airwin2rack
    TAL-plugins-vst2
    neural-amp-modeler-lv2
    dragonfly-reverb
    fire
    wolf-shaper
    luftikus-vst2
    LUFSMeter-vst2
    chow-tape-model
    chow-centaur
    chow-phaser
    auburn-sounds-inner-pitch
    wildergarden-maim
    reevr
    filtr
    gate12
    time12
    spectralsuite
    cstop
    hamburger
  ];

  cfg = config.modules.desktop.audio.plugins.native;
  isAnyDawInstalled = config._internals.isAnyDawInstalled;
in
{
  imports = [
    ./u-he.nix
  ];

  options.modules.desktop.audio.plugins.native = {
    enable = mkOption {
      type = types.bool;
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

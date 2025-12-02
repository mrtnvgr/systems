{ pkgs, config, lib, user, ... }:
let
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

    environment.sessionVariables =
      let
        makePluginPath = format: (lib.concatStringsSep ":" [
          "/home/${user}/.${format}"
          "/etc/profiles/per-user/${user}/lib/${format}"
          "/run/current-system/sw/lib/${format}"
        ]) + ":";
      in
      {
        VST3_PATH = makePluginPath "vst3";
        VST_PATH = makePluginPath "vst";
        CLAP_PATH = makePluginPath "clap";
        LV2_PATH = makePluginPath "lv2";
        LADSPA_PATH = makePluginPath "ladspa";
      };
  };
}

{ pkgs, config, lib, ... }: let
  inherit (lib) mkEnableOption mkIf;

  # TODO: vitalium-vst3 to nurpkgs
  vitalium = pkgs.distrho-ports.override {
    plugins = [ "vitalium" ];
    # TODO: buildLV2 = false;
    # TODO: buildVST2 = false;
  };

  # TODO: create override packages in nurpkgs:
  # - surge-XT-vst3
  # - airwindows-vst3
  # - lsp-plugins-vst3

  synths = with pkgs; [
    surge-XT
    vitalium
  ];

  fx = with pkgs; [
    lsp-plugins
    # FIXME: neuralnote
    neural-amp-modeler-lv2
  ];

  cfg = config.modules.desktop.audio.plugins;
in {
  options.modules.desktop.audio.plugins = {
    # TODO: migrate to mkOption, enable if daws are enabled
    enable = mkEnableOption "audio plugins";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = synths ++ fx;
  };
}

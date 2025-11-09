{ pkgs, config, lib, ... }: let
  inherit (lib) mkEnableOption mkIf;

  synths = with pkgs; [
    surge-XT-vst3
    vitalium-vst3
  ];

  fx = with pkgs; [
    TAL-plugins-vst3
    lsp-plugins
    airwindows
    neural-amp-modeler-lv2
    luftikus-vst3
    LUFSMeter-vst3
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

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
  isAnyDawInstalled = config._internals.isAnyDawInstalled;
in {
  options.modules.desktop.audio.plugins = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = isAnyDawInstalled;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = synths ++ fx;
  };
}

{ config, pkgs, lib, ... }: let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.apps.reaper;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # FIXME: neuralnote
      neural-amp-modeler-lv2
      sfizz
    ];
  };
}

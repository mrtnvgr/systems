{ config, pkgs, lib, user, ... }: let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.apps.reaper;
in {
  config = mkIf cfg.enable {
    # Real-time audio tweaks
    musnix.enable = true;
    musnix.kernel.realtime = true;
    musnix.kernel.packages = pkgs.linuxPackages-rt_latest;
    musnix.rtirq.enable = true;
    musnix.rtcqs.enable = true;

    powerManagement = {
      enable = true;
      cpuFreqGovernor = "performance";
    };

    # Provided by nix-gaming modules
    services.pipewire.lowLatency.enable = true;
    programs.steam.platformOptimizations.enable = true;

    # note: workaround for fufexan/nix-gaming#173
    security.pam.loginLimits = [{
      domain = user;
      item = "nice";
      type = "hard";
      value = "-20";
    }];
  };
}

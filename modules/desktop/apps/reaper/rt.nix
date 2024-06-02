{ config, pkgs, lib, user, ... }: let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.apps.reaper;
in {
  config = mkIf cfg.enable {
    # Real-time audio tweaks
    musnix.enable = true;
    musnix.kernel.packages = pkgs.linuxPackages_latest_rt;

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

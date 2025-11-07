{ inputs, config, lib, user, ... }: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.desktop.audio.rt;
in {
  options.modules.desktop.audio.rt = {
    enable = mkEnableOption "tweaks for real-time audio";
  };

  imports = [
    inputs.musnix.nixosModules.musnix

    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  config = mkIf cfg.enable {
    # Real-time audio tweaks
    musnix.enable = true;

    # musnix.kernel.realtime = true;
    # musnix.kernel.packages = pkgs.linuxPackages_latest_rt;

    # Website that hosts the tarball is down
    # FIXME: musnix.rtirq.enable = true;
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

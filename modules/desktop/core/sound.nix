{ pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop;
in {
  config = mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;

      pulse.enable = true;
      jack.enable = true;
    };

    environment.systemPackages = with pkgs; [ alsa-utils ];
    users.users.${user}.extraGroups = [ "audio" ];
  };
}

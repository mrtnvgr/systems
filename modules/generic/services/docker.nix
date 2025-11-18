{ config, pkgs, lib, user, ... }: {
  options.modules.generic.services.docker = {
    enable = lib.mkEnableOption "Docker";
  };

  config = lib.mkIf config.modules.generic.services.docker.enable {
    virtualisation.docker.enable = true;
    environment.systemPackages = [ pkgs.docker ];
    users.users.${user}.extraGroups = [ "docker" ];
  };

  # cross-compilation for arm handhelds
  # environment.systemPackages = [ pkgs.qemu ];
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}

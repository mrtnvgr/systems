{ config, lib, modulesPath, hostname, user, specialArgs, ... }:
let
  inherit (lib) mkIf mkDefault mkForce;
  persistenceSupport = (toString (specialArgs.persistence or false)) == "1";
in {
  imports = [
    "${modulesPath}/installer/cd-dvd/iso-image.nix"

    # All hardware support
    "${modulesPath}/profiles/all-hardware.nix"
  ];

  # note: iso-image module will generate grub configs
  # !: it's not possible to disable (as of 29.02.2024)
  # it's nice to use systemd-boot to be consistent
  # across different types of installations, however
  # we'll keep using grub, because this system should
  # not be updated anyways.
  boot.loader.systemd-boot.enable = mkForce false;

  # Let's be minimal
  isoImage.forceTextMode = true;

  boot.kernelParams = [ "toram" ];
  # isoImage.bootEntries = [
  #   { class = "default"; }
  #
  #   # Load the entirety of iso into the RAM
  #   { class = "toram"; params = "toram"; }
  # ];

  # EFI, USB booting
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;

  # Get rid of "installer" suffix in boot menu
  isoImage.appendToMenuLabel = "";

  # Specify edition as a hostname
  isoImage.edition = hostname;

  # ZSTD compression
  isoImage.squashfsCompression = "zstd -Xcompression-level 19";

  # Sync filesystems options
  fileSystems = mkDefault config.lib.isoFileSystems;

  # Get rid of swaps
  swapDevices = [ ];

  # Prevent installation media from evacuating persistent storage, as their
  # var directory is not persistent and it would thus result in deletion of
  # those entries.
  environment.etc."systemd/pstore.conf".text = ''
    [PStore]
    Unlink=no
  '';

  # Persistence
  # WARN: home directory has .cache stuff which will slow down the system
  # NOTE: consider using other directory such as /persistence?
  # TODO: set wine directory to that folder
  # TODO: turn OFF any logging?
  lib.isoFileSystems."/home/${user}" = mkIf persistenceSupport {
    device = "/dev/disk/by-label/${hostname}persistence";
    fsType = "ext4";
  };

  formatAttr = "isoImage";
  fileExtension = ".iso";
}

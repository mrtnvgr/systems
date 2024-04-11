{ hostname, modulesPath, lib, config, pkgs, specialArgs, ... }:
let
  rootPartition = "${hostname}-root";
in {
  boot.initrd.availableKernelModules = [ "uas" "usbhid" "usb_storage" ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/${rootPartition}";
    autoResize = true;
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
    options = [ "umask=077" ];
  };

  boot.growPartition = true;

  # boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  system.build.raw = import "${modulesPath}/../lib/make-disk-image.nix" {
    inherit lib config pkgs;

    name = "${hostname}-image";
    label = rootPartition;

    partitionTableType = "efi";
    diskSize = specialArgs.diskSize or "auto";
    format = "raw";
  };

  # Prevent installation media from evacuating persistent storage, as their
  # var directory is not persistent and it would thus result in deletion of
  # those entries.
  environment.etc."systemd/pstore.conf".text = ''
    [PStore]
    Unlink=no
  '';

  formatAttr = "raw";
  fileExtension = ".img";
}

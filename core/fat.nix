{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ fatsort ];
  boot.supportedFilesystems = [ "ntfs" "exfat" "vfat" ];
}

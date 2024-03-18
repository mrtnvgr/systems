{ lib, ... }: {
  options.modules.desktop.enable = lib.mkEnableOption "desktop profile";

  imports = [
    ./hardware.nix
    ./sound.nix
    ./multimedia.nix
    ./fonts.nix
    ./guilibs.nix
    ./packages.nix
    ./network.nix
    ./screenshots.nix
    ./wayland.nix
    ./adb.nix
    ./wallpapers.nix

    ./rices
  ];
}

{ ... }: {
  imports = [
    ./hardware.nix
    ./sound.nix
    ./multimedia.nix
    ./fonts.nix
    ./guilibs.nix
    ./packages.nix
    ./network.nix
    ./screenshots.nix
    ./adb.nix
    ./wallpaper.nix

    ./rices
    ./guiServers
  ];
}

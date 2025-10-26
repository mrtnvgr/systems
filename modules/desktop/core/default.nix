{ ... }: {
  imports = [
    ./graphics.nix
    ./sound.nix
    ./multimedia.nix
    ./fonts.nix
    ./guilibs.nix
    ./packages.nix
    ./network.nix
    ./screenshots.nix
    ./adb.nix
    ./wallpaper.nix
    ./kvm.nix

    ./rices
    ./guiServers
  ];
}

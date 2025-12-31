{ ... }: {
  imports = [
    ./graphics.nix
    ./sound.nix
    ./multimedia.nix
    ./fonts.nix
    ./guilibs.nix
    ./packages.nix
    ./network.nix
    ./adb.nix
    ./wallpaper.nix
    ./kvm.nix
    ./xdg.nix

    ./rices
    ./guiServers
  ];
}

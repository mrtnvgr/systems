{ ... }: {
  imports = [
    ./graphics.nix
    ./sound.nix
    ./multimedia.nix
    ./fonts.nix
    ./guilibs.nix
    ./packages.nix
    ./network.nix
    ./wallpaper.nix
    ./kvm.nix
    ./xdg.nix
    ./colors.nix

    ./rices
    ./guiServers
  ];
}

{ ... }: {
  imports = [
    ./bootloader.nix
    ./nix.nix
    ./packages.nix
    ./fat.nix
    ./overlays.nix
    ./home-manager.nix
    ./time-zone.nix
    ./physlock.nix
    ./nice-build.nix
    ./users.nix
    ./network.nix
    ./registry.nix
    ./git.nix
    ./ssh.nix
    ./neovim
    ./shell.nix
    ./archiving.nix
    ./gpg.nix
    ./firmware.nix
    ./kernel.nix
    ./gc-whitelist.nix
    ./logs.nix
    ./temp.nix
    ./hostname.nix
  ];
}

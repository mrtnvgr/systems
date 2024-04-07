{ pkgs, ... }: {
  imports = [
    # Base
    ../minix

    ./secrets/celeste.nix
    ./secrets/ssh.nix
  ];

  time.timeZone = "Asia/Novosibirsk";
}

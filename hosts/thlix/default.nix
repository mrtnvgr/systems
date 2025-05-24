{ ... }: {
  imports = [
    # Base
    ../minix

    ./secrets/ssh.nix
  ];

  time.timeZone = "Asia/Novosibirsk";
}

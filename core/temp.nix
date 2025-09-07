# https://github.com/NixOS/nixpkgs/issues/336089#issuecomment-2308353273
{ ... }: {
  boot.tmp.useTmpfs = true;

  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp";
  };
}

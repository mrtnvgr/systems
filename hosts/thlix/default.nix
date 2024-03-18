{ pkgs, ... }: {
  imports = [
    # Base
    ../minix

    ./secrets/celeste.nix
    ./secrets/ssh.nix
  ];

  time.timeZone = "Asia/Novosibirsk";

  modules.desktop = {
    apps = {
      # FIXME: fix codeium
      neovim.codeiumConfig = ./secrets/codeium.json;
    };
  };
}

{ pkgs, ... }: {
  imports = [
    # Personal base (base with secrets)
    ../thlix

    ./secrets/reaper.nix
  ];

  modules.desktop = {
    feats = {
      music = {
        enable = true;
        path = "/mnt/ssd/Music/sorted";
      };

      rclone = {
        enable = true;
        config = ./secrets/rclone.conf;
      };
    };

    apps = {
      reaper.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # ghidra
    # (cutter.withPlugins (plugins: with plugins; [ rz-ghidra ]))
  ];
}

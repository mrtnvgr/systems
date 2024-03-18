{ inputs, pkgs, config, lib, ... }: {
  nix = {
    # Use new experimental nix
    package = pkgs.nixFlakes;

    settings = {
      # Enable flakes
      experimental-features = "nix-command flakes";

      # Deduplicate store
      auto-optimise-store = true;

      # Disable "uncommited changes" warning
      warn-dirty = false;
    };

    # Auto garbage-collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

  };

  # Faster rebuilds
  documentation = {
    doc.enable = false;
    dev.enable = false;
    info.enable = false;
  };
}

{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  environment.systemPackages = with pkgs; [
    wget
    htop
    neofetch
    file
    dos2unix
    progress
  ];
}

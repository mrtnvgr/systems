{ lib, ... }: {
  options.modules.desktop.enable = lib.mkEnableOption "desktop profile";

  imports = [
    ./core
    ./feats
    ./apps
    ./dev
    ./games
    ./audio
  ];
}

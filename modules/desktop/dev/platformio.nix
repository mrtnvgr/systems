{ pkgs, lib, config, ... }: let
  cfg = config.modules.desktop.dev.platformio;
in {
  options.modules.desktop.dev.platformio = {
    enable = lib.mkEnableOption "platformio";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ platformio avrdude ];
    services.udev.packages = with pkgs; [ platformio-core.udev openocd ];
  };
}

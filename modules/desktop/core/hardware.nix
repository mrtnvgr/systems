{ lib, config, ... }: {
  config = lib.mkIf config.modules.desktop.enable {
    hardware = {
      enableRedistributableFirmware = true;
      enableAllFirmware = true;

      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}

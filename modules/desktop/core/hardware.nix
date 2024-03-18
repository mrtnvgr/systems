{ lib, config, ... }: {
  config = lib.mkIf config.modules.desktop.enable {
    hardware = {
      enableRedistributableFirmware = true;
      enableAllFirmware = true;

      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
    };
  };
}

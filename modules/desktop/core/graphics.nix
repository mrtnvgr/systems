{ lib, config, ... }: {
  config = lib.mkIf config.modules.desktop.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}

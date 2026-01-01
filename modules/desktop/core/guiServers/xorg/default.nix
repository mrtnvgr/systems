{ lib, config, ... }: {
  config = lib.mkIf (config._internals.guiServer == "xorg") {
    services.xserver.enable = true;

    services.libinput = {
      enable = true;

      mouse.accelProfile = "flat";
      # touchpad.accelProfile = "flat";
    };

    _internals.DELauncher = "startx";
  };
}

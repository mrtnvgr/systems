{ lib, config, ... }: {
  config = lib.mkIf (config._internals.guiServer == "wayland") {
    # Enable experimental Wayland support for Chromium based apps
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}

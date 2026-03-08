{ lib, config, pkgs, ... }: let
  inherit (config.modules.desktop.theme.colorscheme) palette;

  lock = pkgs.writeScriptBin "lock" (with palette; ''
    ${pkgs.waylock}/bin/waylock          \
      -init-color      "0x${void}"       \
      -input-color     "0x${background}" \
      -input-alt-color "0x${background}" \
      -fail-color      "0x${background}" \
      "$@"
  '');
in {
  config = lib.mkIf (config._internals.guiServer == "wayland") {
    environment.systemPackages = [ lock ];
    security.pam.services.waylock = {};

    # Disable automatic physlock runs
    # TODO: move to desktop/core
    # TODO: create automatic runs of waylock
    services.physlock.lockOn = {
      suspend = false;
      hibernate = false;
    };
  };
}

{ lib, config, ... }:
let
  inherit (lib) mkIf;
  theme = config.modules.desktop.theme;
in {
  config = mkIf (theme.rice == "hyprpop") {
    _internals.guiServer = "wayland";
  };

  imports = [
    ./hyprland
    ./waybar
    ./foot
  ];
}

{ lib, ... }: let
  inherit (lib) mkOption types;
in {
  options._internals.guiServer = mkOption {
    type = with types; nullOr (enum [ "xorg" "wayland" ]);
    default = null;
  };

  imports = [
    ./xorg
    ./wayland

    ./autostart.nix
  ];
}

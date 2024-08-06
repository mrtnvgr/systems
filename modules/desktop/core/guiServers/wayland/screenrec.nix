{ lib, config, pkgs, ... }: {
  config = lib.mkIf (config._internals.guiServer == "wayland") {
    environment.systemPackages = with pkgs; [
      wl-clipboard
      wl-screenrec
    ];
  };
}

{ pkgs, lib, user, config, ... }:
let
  screenshot-select = pkgs.writeScriptBin "screenshot-select" "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\"";
  screenshot-full = pkgs.writeScriptBin "screenshot-full" "${pkgs.grim}/bin/grim";
in {
  config = lib.mkIf config.modules.desktop.enable {
    home-manager.users.${user} = {
      home.packages = [ screenshot-select screenshot-full ];
    };
  };
}

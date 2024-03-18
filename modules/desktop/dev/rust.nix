{ pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.desktop.dev.rust;
in {
  options.modules.desktop.dev.rust.enable = mkEnableOption "rust";
  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [
        cargo
        rustc

        rust-analyzer
        clippy
        rustfmt

        gcc
        pkg-config
      ];

      home.sessionPath = [ "$HOME/.cargo/bin" ];
    };
  };
}

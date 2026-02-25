{ pkgs, lib, config, user, ... }: let
  cfg = config.modules.desktop.dev.rust;
in {
  options.modules.desktop.dev.rust.enable = lib.mkEnableOption "rust";

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [ cargo rustc ];
      home.sessionPath = [ "$HOME/.cargo/bin" ];
    };
  };
}

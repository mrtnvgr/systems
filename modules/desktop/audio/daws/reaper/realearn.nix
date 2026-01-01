{ pkgs, lib, config, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;

  pkg = pkgs.reaper-realearn-extension;
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    home.packages = [ pkg ];
    home.file.".config/REAPER/UserPlugins/realearn".source = "${pkg}/lib";
  };
}

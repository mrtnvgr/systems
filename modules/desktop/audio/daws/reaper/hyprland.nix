{ lib, config, user, ... }: let
  reaper = config.modules.desktop.audio.daws.reaper;
in {
  home-manager.users.${user} = lib.mkIf reaper.enable {
    wayland.windowManager.hyprland.extraConfig = ''
      # REAPER tooltip fix
      # https://github.com/hyprwm/Hyprland/issues/2278
      windowrule = no_focus on, match:class REAPER, match:title ^$
    '';
  };
}

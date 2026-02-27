{ lib, config, user, ... }: let
  reaper = config.modules.desktop.audio.daws.reaper;
in {
  home-manager.users.${user} = lib.mkIf reaper.enable {
    wayland.windowManager.hyprland.extraConfig = ''
      # Tooltip fix
      # https://github.com/hyprwm/Hyprland/issues/2278
      windowrule = no_focus on, match:class REAPER, match:title ^$

      # Hide update popups
      windowrule = workspace 5 silent, match:class ^REAPER$, match:title ^About.+

      # Improve actions window styling
      windowrule = center on, stay_focused on, dim_around on, no_anim on, match:class ^REAPER$, match:title ^Actions$
    '';
  };
}

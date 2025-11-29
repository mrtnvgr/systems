{ lib, config, user, pkgs, ... }:
let
  cfg = config.modules.desktop.audio.daws.reaper;
  pkg = pkgs.js_ReaScriptAPI;
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.file.".config/REAPER/UserPlugins/reaper_js_ReaScriptAPI64.so".source = "${pkg}/UserPlugins/reaper_js_ReaScriptAPI64.so";
      home.file.".config/REAPER/UserPlugins/reaper_js_ReaScriptAPI64.dll".source = "${pkg}/UserPlugins/reaper_js_ReaScriptAPI64.dll";
    };
  };
}

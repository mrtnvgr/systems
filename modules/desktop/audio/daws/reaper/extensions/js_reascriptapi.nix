{ lib, config, user, pkgs, ... }:
let
  cfg = config.modules.desktop.audio.daws.reaper;
  pkg = pkgs.js_ReaScriptAPI;
in {
  options.modules.desktop.audio.daws.reaper = {
    extensions.js_ReaScriptAPI.enable = lib.mkEnableOption "REAPER js_ReaScriptAPI extension";
  };

  config = lib.mkIf cfg.extensions.js_ReaScriptAPI.enable {
    home-manager.users.${user} = {
      home.file.".config/REAPER/UserPlugins/reaper_js_ReaScriptAPI64.so".source = "${pkg}/UserPlugins/reaper_js_ReaScriptAPI64.so";
      home.file.".config/REAPER/UserPlugins/reaper_js_ReaScriptAPI64.dll".source = "${pkg}/UserPlugins/reaper_js_ReaScriptAPI64.dll";
    };
  };
}

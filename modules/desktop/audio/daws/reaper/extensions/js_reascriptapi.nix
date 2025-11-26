{ lib, config, user, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.audio.daws.reaper;

  # TODO: move to nurpkgs
  js_reascriptapi = pkgs.callPackage ./TEMP.nix { };
in {
  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.file.".config/REAPER/UserPlugins/reaper_js_ReaScriptAPI64.so".source = "${js_reascriptapi}/UserPlugins/reaper_js_ReaScriptAPI64.so";
      home.file.".config/REAPER/UserPlugins/reaper_js_ReaScriptAPI64.dll".source = "${js_reascriptapi}/UserPlugins/reaper_js_ReaScriptAPI64.dll";
    };
  };
}

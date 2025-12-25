{ inputs, lib, config, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
  script = "${inputs.reascripts}/Various/amagalma_Smart contextual zoom.lua";
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    programs.reanix = {
      scripts.smartzoom = {
        source = script;
        key = "0 96"; # `
      };

      extensions.js_ReaScriptAPI.enable = true;
    };
  };
}

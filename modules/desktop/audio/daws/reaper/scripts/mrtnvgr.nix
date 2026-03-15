{ inputs, lib, config, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
  scripts = "${inputs.mrtnvgr-rea}/scripts/mrtnvgr_";
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    programs.reanix.scripts."Unarm all, arm selected" = {
      source = "${scripts}Unarm all, arm selected.lua";

      # TODO: use https://mespotin.uber.space/IniFiles/Reaper-KEY-Codes_for_reaper-kb_ini.ini
      key = "1 65"; # A
    };
  };
}

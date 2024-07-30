{ inputs, lib, config, user, ... }: let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.apps.reaper;
in {
  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.file.".config/REAPER/Effects/Geraint".source = inputs.jsfx-geraint;
      home.file.".config/REAPER/Effects/ReJJ".source = inputs.jsfx-rejj;
      home.file.".config/REAPER/Effects/chkhld".source = inputs.jsfx-chkhld;
    };
  };
}

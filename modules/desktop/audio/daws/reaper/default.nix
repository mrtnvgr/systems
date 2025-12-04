{ lib, config, inputs, user, ... }:
let
  cfg = config.modules.desktop.audio.daws.reaper;
in {
  options.modules.desktop.audio.daws.reaper = {
    enable = lib.mkEnableOption "REAPER";
  };

  config = lib.mkIf cfg.enable {
    _internals.isAnyDawInstalled = true;

    home-manager.users.${user} = {
      imports = [ inputs.reanix.homeModules.default ];
      programs.reanix.enable = true;
      # TODO: programs.reanix.preRunHook = ''${lib.optionalString desktopCfg.audio.plugins.wine.enable "wine-audio-plugins-activate"}'';
    };
  };

  imports = [
    ./theme
    ./config.nix
    ./scripts
    ./templates
  ];
}

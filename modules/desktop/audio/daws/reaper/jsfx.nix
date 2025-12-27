{ inputs, lib, config, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;

  jsfx = ".config/REAPER/Effects/nix";
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    home.file."${jsfx}/mrtnvgr".source = inputs.mrtnvgr-jsfx;
  };
}

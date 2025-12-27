{ inputs, lib, config, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;

  jsfx = ".config/REAPER/Effects/nix";
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    home.file."${jsfx}/mrtnvgr".source = inputs.mrtnvgr-jsfx;

    home.file."${jsfx}/chkhld/signal_crusher.jsfx".source = "${inputs.chkhld-jsfx}/Lo-Fi/signal_crusher.jsfx";
    home.file."${jsfx}/chkhld/telephone.jsfx".source = "${inputs.chkhld-jsfx}/Lo-Fi/telephone.jsfx";
  };
}

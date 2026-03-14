{ inputs, lib, config, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
  jsfx = ".config/REAPER/Effects/nix";
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    home.file."${jsfx}/mrtnvgr".source = "${inputs.mrtnvgr-rea}/jsfx";

    home.file."${jsfx}/chkhld/signal_crusher.jsfx".source = "${inputs.chkhld-jsfx}/Lo-Fi/signal_crusher.jsfx";
    home.file."${jsfx}/chkhld/telephone.jsfx".source = "${inputs.chkhld-jsfx}/Lo-Fi/telephone.jsfx";

    home.file."${jsfx}/jclones/Fattener.jsfx".source = "${inputs.jsfx-clones}/jsfx/JClones_Fattener.jsfx";
    home.file."${jsfx}/jclones/O3_Maximizer.jsfx".source = "${inputs.jsfx-clones}/jsfx/JClones_O3_Maximizer.jsfx";
    home.file."${jsfx}/jclones/Classic_Master_Limiter.jsfx".source = "${inputs.jsfx-clones}/jsfx/JClones_Classic_Master_Limiter.jsfx";

    home.file."${jsfx}/saike/seqs".source = "${inputs.saike-jsfx}/SequencedFX";

    home.file."${jsfx}/tukan".source = inputs.tukan-jsfx;
  };
}

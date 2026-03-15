{ inputs, config, user, lib, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
  scr = "${inputs.birdbird}/Global Sampler/BirdBird_";
  jsfx = ".config/REAPER/Effects/nix";
in {
  home-manager.users.${user} = lib.mkIf cfg.enable ({ lib, ... }: {
    programs.reanix.scripts = {
      "Global Sampler".source = "${scr}Global Sampler.lua";
      "Sample Last X Seconds".source = "${scr}Sample Last X Seconds.lua";
      "Sample Last Playthrough".source = "${scr}Sample Last Playthrough.lua";
      "Global Sampler Theme Editor".source = "${scr}Global Sampler Theme Editor.lua";
    };

    programs.reanix.extensions = {
      js_ReaScriptAPI.enable = true;
      sws.enable = true;
    };

    home.file."${jsfx}/_internal/BirdBird_Global Sampler.jsfx".source = "${inputs.birdbird}/Global Sampler/BirdBird_Global Sampler.jsfx";

    # Script saves "theme.json" settings file there, the directory must be writable
    home.activation.globalSamplerLibraries = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      DEST="$HOME/.config/REAPER/Scripts/nix/global_sampler_libraries"
      install -DC "${inputs.birdbird}/Global Sampler/global_sampler_libraries"/*.lua "$DEST"
    '';
  });
}

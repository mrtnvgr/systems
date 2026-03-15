{ config, user, lib, ... }:
let
  cfg = config.modules.desktop.audio.daws.reaper;
in {
  home-manager.users.${user} = lib.mkIf cfg.enable {
    programs.reanix.config = {
      boot.animation = false;

      # do not repeat at end of project
      playback.loop = true;

      grid.dotted = false;

      media_explorer.media.loop = false;

      default_track_height = "small";

      # Item fades
      fades.default_length = 1; # ms

      # Clean items
      display_media_item_take_name = false;
      draw_labels_above_the_item.enable = false;
      item_icons.min_height = 90;

      continuous_scrolling = true;

      draw_faint_peaks_in_folders = false;
      draw_faint_peaks_in_automation_lanes = false;

      filled_automation_envelopes = false;

      mixer.dock = true;
      # TODO: reanix.config.mixer.docker.position = "down";

      media_explorer.dock = true;
      # TODO: reanix.config.mixer.docker.position = "down";
      # dockermode2 ??
      # [REAPERdockpref] ??
    };

    programs.reanix.extraConfig = {
      "reaper.ini" = /* dosini */ ''
        ; Load a new project on startup
        [reaper]
        loadlastproj=19

        ; Disable media item extending
        [reaper]
        mousemovemod=16

        ; 8th notes grid by default
        [reaper]
        projgriddiv=0.5

        ; Draw grid UNDER items :)
        [reaper]
        gridinbg=2

        ; Disable item looping
        [reaper]
        loopnewitems=32

        ; Zoom in/out on mouse cursor
        [reaper]
        zoommode=3

        ; Render with high buffer block size
        [reaper]
        renderbsnew=1024

        ; Midi editor: note color = track color
        [reaper]
        colorwhat=4

        ; !
        ; Show only VST3 plugin if other formats were found
        [reaper]
        dupefilter=1

        ; Track folder collapsing: normal, hidden
        [reaper]
        tcpalign=769

        ; Discard incomplete takes
        [reaper]
        recaddatloop=4

        ; !
        ; Hide deletion prompt on record stop
        [reaper]
        promptendrec=0

        ; !
        ; Hide velocity handles
        [midiedit]
        lastvelhand=0

        ; !
        ; Bigger track spacers
        [reaper]
        trackgapmax=24

        ; !
        ; Faster waveforms
        [reaper]
        recupdatems=33

        ; !
        ; Faster meters
        [reaper]
        vudecay=40

        ; Lower media buffer size
        [reaper]
        workbufmsex=600
        prebufperb=50

        ; Middle mouse -> hand scroll navigation
        [midiedit]
        scnotes=128

        ; !
        ; Media explorer: samples path
        [reaper_sexplorer]
        lastdir=/home/${user}/Samples
      '';

      "reaper-kb.ini" = /* dosini */ ''
        ; Recording shortcuts
        KEY 1 69 1013 0          # Main : E : Transport: Record
        KEY 1 81 40668 0         # Main : Q : Transport: Stop (DELETE all recorded media)

        ; Slice at cursor position
        KEY 1 83 42577 0		 # Main : S : OVERRIDE DEFAULT : Item: Split item under mouse cursor (select right)

        ; Item editing shortcuts
        KEY 0 42 40205 0		 # Main : * (Ctrl + 8) : Item properties: Pitch item down one semitone
        KEY 0 40 40204 0		 # Main : ( (Ctrl + 9) : Item properties: Pitch item up one semitone
        KEY 0 41 41051 0		 # Main : ) (Ctrl + 0) : Item properties: Toggle take reverse

        ; Fast track coloring
        KEY 1 67 _SWS_TRACKRANDCOL 0		 # Main : C : OVERRIDE DEFAULT : SWS: Set selected track(s) to one random custom color

        KEY 13 82 _SWS_AWCONSOLSEL 0		 # Main : Ctrl+Shift+R : SWS/AW: Consolidate Selection
      '';

      "reaper-mouse.ini" = /* dosini */ ''
        ; One-click midi note inserting
        ; (Use Shift+Click to unselect)
        [MM_CTX_MIDI_PIANOROLL_CLK]
        mm_0=4 m

        ; Adjust fades when multiple clips are selected
        [MM_CTX_ITEMFADE]
        mm_0=9 m

        ; Select items without cursor moving
        [MM_CTX_ITEM_CLK]
        mm_0=3 m

        ; Ctrl + drag: draw selected midi item (default) => draw empty item
        [MM_CTX_TRACK]
        mm_2=5 m

        ; Ctrl + draw: adjust item volume
        [MM_CTX_ITEM]
        mm_2=20 m
      '';
    };
  };
}

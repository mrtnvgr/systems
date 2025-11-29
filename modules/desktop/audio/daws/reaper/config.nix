{ lib, config, user, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.audio.daws.reaper;
in {
  config = mkIf cfg.enable {
    modules.desktop.audio.daws.reaper.config = {
      "reaper.ini" = /* dosini */ ''
        ; Set a theme
        [reaper]
        lastthemefn5=/home/${user}/.config/REAPER/ColorThemes/Reapertips.ReaperTheme

        ; Disable version checking
        [reaper]
        verchk=0

        ; Disable boot animation
        [reaper]
        splashfast=1

        ; Save reapeaks in a cache directory
        [reaper]
        altpeaks=5
        altpeakspath=/home/${user}/.local/REAPER/Peaks

        ; Load a new project on startup
        [reaper]
        loadlastproj=19

        ; Never stop playback, replay the project
        [reaper]
        stopprojlen=0

        ; Disable fade-in on playback start
        [reaper]
        hwfadex=1

        ; Disable media item extending
        [reaper]
        mousemovemod=16

        ; Disable item looping
        [reaper]
        loopnewitems=32

        ; Zoom in/out on mouse cursor
        [reaper]
        zoommode=3

        ; Render with high buffer block size
        [reaper]
        renderbsnew=1024

        ; Hide mixer and transport by default
        [reaper]
        mixwnd_vis=0
        transport_vis=0

        ; 8th notes grid by default
        [reaper]
        projgriddiv=0.5

        ; Midi editor: note color = track color
        [reaper]
        colorwhat=4

        ; Solid grid lines
        [reaper]
        griddot=0

        ; Continious scrolling
        [reaper]
        viewadvance=19

        ; Show only VST3 plugin if other formats were found
        [reaper]
        dupefilter=1

        ; 1ms item fades
        [reaper]
        deffadelen=0.001
        defsplitxfadelen=0.001

        ; Turn off dots on items
        [reaper]
        labelitems2=1039

        ; Track folder collapsing: normal, hidden
        [reaper]
        tcpalign=769

        ; Discard incomplete takes
        [reaper]
        recaddatloop=4

        ; Hide deletion prompt on record stop
        [reaper]
        promptendrec=0
      '';

      "reaper-kb.ini" = /* dosini */ ''
        ; Action: Create new auto record-armed MIDI track
        ; Mapped to: Ctrl + Shift + T
        ; - Track: Insert new track
        ; - SWS/S&M: Set selected tracks MIDI input to all channels
        ; - Track: Set automatic record-arm when track selected
        ACT 0 0 "0ab211ac849521218f581e3d86c66438" "Custom: Create new auto record-armed MIDI track" 40001 _S&M_MIDI_INPUT_ALL_CH 40737
        KEY 13 84 _0ab211ac849521218f581e3d86c66438 0 # Ctrl+Shift+T : Custom: Create new auto record-armed MIDI track

        ; Recording shortcuts
        KEY 1 69 1013 0  # E : Transport: Record
        KEY 1 81 40668 0 # Q : Transport: Stop (DELETE all recorded media)

        ; Slice at cursor position
        KEY 1 83 42577 0		 # Main : S : OVERRIDE DEFAULT : Item: Split item under mouse cursor (select right)

        ; C -> open a color picker
        KEY 1 67 _RS0d28c2303f1d9580d2d9243a756c2c4fa0588e05 0
      '';

      "reaper-mouse.ini" = /* dosini */ ''
        ; One-click midi note inserting
        ; (Use Shift+Click to unselect)
        [MM_CTX_MIDI_PIANOROLL_CLK]
        mm_0=4 m

        ; Adjust fades when multiple clips are selected
        [MM_CTX_ITEMFADE]
        mm_0=9 m
      '';
    };
  };
}

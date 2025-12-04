{ inputs, config, pkgs, lib, user, ... }:
let
  mrtnvgr-lib = inputs.mrtnvgr.lib { inherit pkgs; };

  cfg = config.modules.desktop.audio.daws.reaper;

  trackOptions = {
    record = {
      # null -> use default track settings
      # (also, these options will be ignored: `input`)
      enable = lib.mkOption {
        type = with lib.types; nullOr bool;
        default = null;
      };

      # Takes in an int, but supports aliases:
      # - <none>, <all_midi>
      # note: isn't used when `record.enable` = null
      input = lib.mkOption {
        type = lib.types.singleLineStr;
        default = "<none>";
      };

      armOnSelect = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
  track = lib.types.submodule { options = trackOptions; };

  recordInputAliases = {
    "<none>" = "-1";
    "<all_midi>" = "5088";
  };
  getRecordInput = x: mrtnvgr-lib.strings.unalias recordInputAliases x.record.input;

  mkTrackTemplate = name: value: pkgs.writeText "${name}.RTrackTemplate" ''
    <TRACK
      NAME ${mrtnvgr-lib.strings.quote name}

      ${lib.optionalString (value.record.enable != null) ''
        REC ${if value.record.enable then "1" else "0"} ${getRecordInput value} 1 0 0 0 0 0
      ''}

      ${lib.optionalString value.record.armOnSelect "AUTO_RECARM 1"}
    >
  '';
in {
  # TODO: generate a script (action?) for each template that adds it

  options.modules.desktop.audio.daws.reaper = {
    templates.tracks = lib.mkOption {
      type = with lib.types; attrsOf track;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.file = lib.mapAttrs' (name: value:
        lib.nameValuePair
          ".config/REAPER/TrackTemplates/${name}.RTrackTemplate"
          { source = mkTrackTemplate name value; }
      ) cfg.templates.tracks;
    };
  };
}

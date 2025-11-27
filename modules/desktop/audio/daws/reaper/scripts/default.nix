{ lib, config, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
in {
  imports = [
    ./MKSlicer.nix
    ./MKShaperStutter.nix
    ./ColorPalette.nix
  ];

  # TODO: migrate to this:
    # cfg.scripts.Test1.source = <path>; (type = path)
    # cfg.scripts.Test1.key = "47"; (type = nullOr str)

  options.modules.desktop.audio.daws.reaper = {
    scripts = lib.mkOption {
      type = with lib.types; attrsOf path;
      default = {};
    };

    scriptMappings = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.file = lib.mapAttrs' (name: value:
        lib.nameValuePair
          ".config/REAPER/Scripts/nix/${name}.lua"
          { source = value; }
      ) cfg.scripts;
    };

    modules.desktop.audio.daws.reaper.config."reaper-kb.ini" = let
      toHash = x: builtins.hashString "sha1" x;

      scriptRegistry = lib.mapAttrsToList (name: value: ''
        SCR 4 0 RS${toHash name} "Script: ${name} (from nix)" nix/${name}.lua
      '') cfg.scripts;

      mappingRegistry = lib.mapAttrsToList (name: value: ''
        KEY 0 ${value} _RS${toHash name} 0
      '') cfg.scriptMappings;
    in
      lib.concatLines (scriptRegistry ++ mappingRegistry);
  };
}

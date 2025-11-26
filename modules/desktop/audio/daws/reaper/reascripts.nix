{ inputs, lib, config, user, ... }: let
  inherit (lib) mkIf;

  toHash = x: builtins.hashString "sha1" x;

  cfg = config.modules.desktop.audio.daws.reaper;

  scripts = {
    MKSlicer = "${inputs.reascripts}/Items Editing/cool_MK Slicer.lua";
    MKShaperStutter = "${inputs.reascripts}/Envelopes/cool_MK ShaperStutter.lua";

    ColorPalette = "${inputs.reascripts}/Various/rodilab_Color palette.lua";
  };

  mappings = {
    ColorPalette = "47"; # /
  };

  scriptRegistry = lib.mapAttrsToList (name: value: ''
    SCR 4 0 RS${toHash name} "Script: ${name} (from nix)" nix/${name}.lua
  '') scripts;

  mappingRegistry = lib.mapAttrsToList (name: value: ''
    KEY 0 ${value} _RS${toHash name} 0
  '') mappings;

  registry = lib.concatLines (scriptRegistry ++ mappingRegistry);
in {
  config = mkIf cfg.enable {
    modules.desktop.audio.daws.reaper.config."reaper-kb.ini" = registry;

    home-manager.users.${user} = {
      home.file = lib.mapAttrs' (name: value:
        lib.nameValuePair
          ".config/REAPER/Scripts/nix/${name}.lua"
          { source = value; }
      ) scripts;
    };
  };
}

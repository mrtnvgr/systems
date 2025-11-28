{ lib, config, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;

  scriptOptions = {
    source = lib.mkOption {
      type = lib.types.path;
    };

    key = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
    };
  };
in {
  imports = [
    ./MKSlicer.nix
    ./MKShaperStutter.nix
    ./ColorPalette.nix
  ];

  options.modules.desktop.audio.daws.reaper = {
    scripts = lib.mkOption {
      type = with lib.types; attrsOf (submodule {
        options = scriptOptions;
      });
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.file = lib.mapAttrs' (name: value:
        lib.nameValuePair
          ".config/REAPER/Scripts/nix/${name}.lua"
          { inherit (value) source; }
      ) cfg.scripts;
    };

    modules.desktop.audio.daws.reaper.config."reaper-kb.ini" = let
      toHash = x: builtins.hashString "sha1" x;

      scriptRegistry = lib.mapAttrsToList (name: value: ''
        SCR 4 0 RS${toHash name} "Script: ${name} (from nix)" nix/${name}.lua
      '') cfg.scripts;

      mappedScripts = lib.filterAttrs (name: value: value.key != null) cfg.scripts;

      mappingRegistry = lib.mapAttrsToList (name: value: ''
        KEY 0 ${value.key} _RS${toHash name} 0
      '') mappedScripts;
    in
      lib.concatLines (scriptRegistry ++ mappingRegistry);
  };
}

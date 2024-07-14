# Workaround to keep stuff safe from the garbage collector
{ config, lib, user, ... }: let
  inherit (lib) mkOption types;
  inherit (builtins) listToAttrs hashString;

  hash = x: hashString "sha256" (toString x);
in {
  options.gc.whitelist = mkOption {
    type = with types; listOf pathInStore;
    description = "Keep certain /nix/store paths safe from gc";
    default = [ ];
  };

  config = {
    home-manager.users.${user} = {
      home.file = listToAttrs (map (x: { name = ".local/state/gc-whitelist/${hash x}"; value = { source = x; }; }) config.gc.whitelist);
    };
  };
}

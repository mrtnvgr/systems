{ lib, config, user, ... }: let
  inherit (builtins) listToAttrs filter;
  inherit (lib) mkIf;

  cfg = config.modules.desktop.apps.reaper;
  hash = x: builtins.hashString "sha256" (toString x);

  isStorePath = let
    inherit (builtins) substring stringLength;
    prefix = "/nix/store";
  in x: (substring 0 (stringLength prefix) x) == prefix;
  filterStorePaths = x: filter isStorePath x;
in {
  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      # Workaround to keep stuff safe from the garbage collector
      home.file = let
        mkState = group: set: listToAttrs (map (x: { name = ".local/state/reaper/${group}/${hash x}"; value = { source = x; }; }) set);

        plugins = mkState "plugins" cfg.plugins;
        data = mkState "data" (filterStorePaths (map (x: x.src) cfg.data));
        regFiles = mkState "regs" cfg.regFiles;
      in plugins // data // regFiles;
    };
  };
}

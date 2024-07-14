{ lib, config, ... }: let
  inherit (builtins) filter;
  inherit (lib) mkIf isStorePath;
  cfg = config.modules.desktop.apps.reaper;
in {
  config = mkIf cfg.enable {
    gc.whitelist = let
      plugins = cfg.plugins;
      data = filter isStorePath (map (x: x.src) cfg.data);
      regFiles = cfg.regFiles;
    in plugins ++ data ++ regFiles;
  };
}

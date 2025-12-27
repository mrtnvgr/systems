{ lib, config, inputs, user, ... }:
let
  desktopCfg = config.modules.desktop;
  cfg = desktopCfg.audio.daws.reaper;
in {
  # TODO: use nixpkgs reaimgui when its merged upstream
  # TODO: https://github.com/NixOS/nixpkgs/pull/464016

  options.modules.desktop.audio.daws.reaper = {
    enable = lib.mkEnableOption "REAPER";
  };

  config = lib.mkIf cfg.enable {
    _internals.isAnyDawInstalled = true;

    home-manager.users.${user} = {
      imports = [ inputs.reanix.homeModules.default ];

      programs.reanix = {
        enable = true;

        hooks.preRun = ''
          ${lib.optionalString desktopCfg.audio.plugins.wine.enable "wine-audio-plugins-activate"}
        '';
      };
    };
  };

  imports = [
    ./theme
    ./config.nix
    ./scripts
    ./templates
    ./jsfx.nix
  ];
}

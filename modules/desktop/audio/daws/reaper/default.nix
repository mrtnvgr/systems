{ pkgs, lib, config, inputs, user, ... }:
let
  desktopCfg = config.modules.desktop;
  cfg = desktopCfg.audio.daws.reaper;

  # TODO: https://github.com/NixOS/nixpkgs/pull/467114
  reaper = pkgs.callPackage (pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/mrtnvgr/nixpkgs/6d3989c9ace8c33af26e8dad0004100e71b94a82/pkgs/applications/audio/reaper/default.nix";
    hash = "sha256-NSiMAM2yLJ8S8Dw0IDrajMoqDze8O1Zl6kKOd1vDaXo=";
  }) {
    jackLibrary = pkgs.libjack2;
    ffmpeg = pkgs.ffmpeg_4-headless;
  };
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
        package = reaper;

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
  ];
}

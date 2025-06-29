{ inputs, pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  inherit (pkgs) writeShellScriptBin;
  cfg = config.modules.desktop.apps.renoise;

  jackAssertion = let
    jackdCfg = config.services.jack.jackd;
    pipewireCfg = config.services.pipewire;
    isJackEnabled = jackdCfg.enable || (pipewireCfg.enable && pipewireCfg.jack.enable);
    error = "To have a great audio in Renoise, please enable JACK or its emulation in PipeWire.";
  in { assertion = isJackEnabled; message = error; };
in {
  options.modules.desktop.apps.renoise = {
    enable = mkEnableOption "renoise";
    releasePath = mkOption { type = with types; nullOr path; default = null; };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = let
      renoise = if (cfg.releasePath != null) then pkgs.renoise.override { releasePath = cfg.releasePath; } else pkgs.renoise;
      renoise-jack = writeShellScriptBin "renoise" "exec ${pkgs.pipewire.jack}/bin/pw-jack ${renoise}/bin/renoise";
    in [ renoise-jack ];

    home-manager.users.${user} = {
      home.file.".config/Renoise/V3.4.4/Themes/catppuccin".source = "${inputs.catppuccin-renoise}/themes";
    };

    assertions = [ jackAssertion ];
  };
}

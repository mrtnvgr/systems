{ inputs, pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  inherit (pkgs) writeShellScriptBin;

  cfg = config.modules.desktop.apps.renoise;

  version = "V3.4.4";
  path = ".config/Renoise/${version}";

  jackAssertion = let
    jackdCfg = config.services.jack.jackd;
    pipewireCfg = config.services.pipewire;
    isJackEnabled = jackdCfg.enable || (pipewireCfg.enable && pipewireCfg.jack.enable);
    error = "Renoise: Please enable JACK or its emulation in PipeWire for low latency audio";
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
      # Themes
      home.file."${path}/Themes/catppuccin".source = "${inputs.catppuccin-renoise}/themes";

      # Tools
      home.file."${path}/Scripts/Tools/com.duftetools.SimplePianoroll.xrnx".source = inputs.renoise-pianoroll;
    };

    assertions = [ jackAssertion ];
  };
}

{ inputs, pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  inherit (pkgs) writeShellScriptBin;

  cfg = config.modules.desktop.apps.renoise;

  # TODO: alsa is completely broken in renoise :/
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
    version = mkOption { type = types.str; default = "V3.5.1"; };
  };

  config = mkIf cfg.enable {
    assertions = [ jackAssertion ];

    environment.systemPackages = let
      renoise = if (cfg.releasePath != null) then pkgs.renoise.override { releasePath = cfg.releasePath; } else pkgs.renoise;
      renoise-jack = writeShellScriptBin "renoise" "exec ${pkgs.pipewire.jack}/bin/pw-jack ${renoise}/bin/renoise";
    in [ renoise-jack pkgs.rubberband ];

    # TODO: https://github.com/nix-community/home-manager/issues/3090
    # with that feature, this logic can be immensely simplified (onChange -> symlink=false)
    home-manager.users.${user} = let
      renoisePath = ".config/Renoise/${cfg.version}";

      themes = { "${renoisePath}/Themes/catppuccin".source = "${inputs.catppuccin-renoise}/themes"; };

      tools = [
        rec { name = "com.renoise.TempoTap.xrnx";
              source = "${inputs.renoise-tools}/Tools/${name}"; }

            { name = "com.duftetools.SimplePianoroll.xrnx";
              source = inputs.renoise-pianoroll; }

            { name = "com.dlt.RubberBandAid";
              source = inputs.renoise-rubberbandaid-tool; }
      ];

      mkTool = tool: {
        "${renoisePath}/Scripts/Tools/${tool.name}" = {
          source = tool.source;
          onChange = ''
            TOOLS="/home/${user}/${renoisePath}/Scripts/Tools"
            rm -rf "$TOOLS/${tool.name}"
            cp -r "${tool.source}" "$TOOLS/${tool.name}"
            chmod -R u+w "$TOOLS/${tool.name}"
          '';
        };
      };
    in {
      home.file = themes // (lib.mergeAttrsList (map mkTool tools));
    };
  };
}

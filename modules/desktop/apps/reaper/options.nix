{ files }:
{ inputs, pkgs, lib, ... }: let
  inherit (lib) mkEnableOption mkOption types;
  arch = pkgs.stdenv.targetPlatform.linuxArch;
in {
  options.modules.desktop.apps.reaper = {
    enable = mkEnableOption "reaper";

    plugins = mkOption {
      type = with types; listOf path;
      default = [
        (pkgs.fetchzip {
          name = "Pitchproof";
          url = "https://aegeanmusic.com/sitedownload/pitchproof.zip";
          hash = "sha256-tJWPP3QTmwWxOTuMvwi4OxM3lArGN8GoqU0/3G+cnYY=";
          stripRoot = false;
        } + "/pitchproof${if arch == "x86_64" then "-x64" else ""}.dll")

        (pkgs.fetchzip {
          name = "TSE808";
          url = "https://www.tseaudio.com/files/TSE808_win64.zip";
          hash = "sha256-gHpC71bkoNUcALxyLOpGFVHJlTe01hYAnfnpLcXMsOY=";
          stripRoot = false;
        } + "/TSE_808_2.0_x64.dll")

        (pkgs.fetchurl {
          name = "NeuralAmpModeler";
          url = "https://cdn.unixis.fun/NeuralAmpModeler.vst3";
          hash = "sha256-j8Cuh6djfnaK8doWyGHOc6LlyHgFkcf9Plwc0C8B9/g=";
        })
      ];
    };

    data = mkOption {
      type = types.listOf (types.submodule {
        options = {
          src = mkOption { type = types.path; };
          dest = mkOption { type = types.str; };
          symlink = mkOption { type = types.bool; default = true; };
          linkContents = mkOption { type = types.bool; default = false; };
        };
      });

      default = [
        # Neural DSP (Stock presets)
        {
          src = "${inputs.ndsp-presets}";
          dest = "ProgramData/Neural DSP";
          linkContents = true;
        }

        # Neural DSP: Archetype Gojira (User presets)
        {
          src = "${files}/presets/gojira";
          dest = "ProgramData/Neural DSP/Archetype Gojira/User";
        }

        # Neural DSP: Archetype Nolly (User presets)
        {
          src = "${files}/presets/nolly";
          dest = "ProgramData/Neural DSP/Archetype Nolly/User";
        }

        # Neural DSP: OMEGA Ampworks Granophyre (User presets)
        {
          src = "${files}/presets/granophyre";
          dest = "ProgramData/Neural DSP/OMEGA Ampworks Granophyre/User";
        }

        # Neural DSP: Archetype Plini (User presets)
        {
          src = "${files}/presets/plini";
          dest = "ProgramData/Neural DSP/Archetype Plini/User";
        }
      ];
    };

    regFiles = mkOption {
      type = with types; listOf path;
      default = [ ];
    };

    extraPreRunScript = mkOption {
      type = types.str;
      default = "";
    };
  };
}

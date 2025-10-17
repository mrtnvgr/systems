# ---------------- NOTE: ------------------
# Don't forget to update avoid-gc.nix file,
# when adding new options here
# -----------------------------------------

{ pkgs, lib, ... }: let
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

      default = [];
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

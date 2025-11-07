{ pkgs, config, lib, user, ... }: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.modules.desktop.audio.plugins.wine;

  yabridge = pkgs.yabridge.override { wine = cfg.package; };
  yabridgectl = pkgs.yabridgectl.override { wine = cfg.package; };

  env = pkgs.mkWineEnv {
    name = "env_audio-plugins";

    # TODO: to fix child window rendering (e.g. kontakt 7), use wine-tkg with patches from proton
    tricks = [ "mfc42" "vcrun2022" "gdiplus" "dxvk" ];

    # TODO: Migrate to runLocalCommand
    setupScript = let
      dataScript = let
        getCopyMethod = x: if (x.symlink && !x.linkContents) then
          "ln -s"
        else if x.linkContents then
          "cp -rs"
        else
          "cp -r";

        mkData = x: /* bash */ ''
          DSTPATH="$HOME/.wine-nix/reaper/drive_c/${x.dest}"
          mkdir --mode=755 -pv "`dirname "$DSTPATH"`"
          ${getCopyMethod x} -vf "${x.src}" "$DSTPATH"

          # https://superuser.com/a/91938
          find "$DSTPATH" -type d -exec chmod 755 {} +
          find "$DSTPATH" -type f -exec chmod 644 {} +
        '';
      in
        lib.concatMapStringsSep "\n" mkData cfg.data;

      regScript = lib.concatMapStringsSep "\n" (x: "wine regedit ${x}") cfg.regFiles;

      script = lib.concatStringsSep "\n" [
        "echo Copying data..."
        dataScript

        "echo Applying reg files..."
        regScript
      ];
    in script;
  };
in {
  options.modules.desktop.audio.plugins.wine = {
    enable = mkEnableOption "Windows audio plugins through WINE";

    package = mkOption {
      type = types.package;
      default = pkgs.wine-staging;
    };

    # TODO: rename to binaries
    plugins = mkOption {
      type = with types; listOf path;
      default = [
        (pkgs.fetchzip {
          name = "Pitchproof";
          url = "https://aegeanmusic.com/sitedownload/pitchproof.zip";
          hash = "sha256-tJWPP3QTmwWxOTuMvwi4OxM3lArGN8GoqU0/3G+cnYY=";
          stripRoot = false;
        } + "/pitchproof-x64.dll")
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
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = { lib, ... }: {
      home.packages = [ yabridge yabridgectl env ];

      home.file.".config/yabridgectl/config.toml".text = let
        plugins = cfg.plugins ++ [ "/home/${user}/.wplugs" ];
      in ''
        plugin_dirs = [${lib.concatStringsSep ", " (map (x: "\"${x}\"") plugins)}]
      '';

      # Do not isolate VST2 plugins
      home.file.".vst/yabridge/yabridge.toml".text = ''
        ["*"]
        group = "all"
      '';

      home.activation.yabridge-sync = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD ${yabridgectl}/bin/yabridgectl sync -p -n $VERBOSE_ARG
      '';
    };

    gc.whitelist = let
      plugins = cfg.plugins;
      data = map (x: x.src) cfg.data;
      regFiles = cfg.regFiles;
    in lib.filter lib.isStorePath (plugins ++ data ++ regFiles);

    # TODO: gc deletes plugins
    # TODO: link files via hm
    # TODO: .wine-nix/reaper/{regs, data, plugins}
    # TODO: prefix without dxvk?
  };
}

{ inputs, pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf concatStringsSep;

  cfg = config.modules.desktop.apps.reaper;

  files = "${config.flakePath}/modules/desktop/apps/reaper";

  # winePkg = inputs.nix-gaming.packages.${pkgs.system}.wine-tkg;
  winePkg = pkgs.wineWowPackages.stagingFull;
  reaper-yabridge = pkgs.yabridge.override { wine = winePkg; };
  reaper-yabridgectl = pkgs.yabridgectl.override { wine = winePkg; };

  reaper-wrapped = let
    # Used to protect some values for privacy reasons
    privateFiles = [
      {
        name = "reaper.ini";

        # note: use "..*" instead of ".+"
        settings = [
          "importpath"
          "^lastproject" "^lastprojuiref" "^lastscript"
          "^projecttab.+"
          "wnd_(h|w|x|y)"
          "^BR - StartupVersionCheck"
        ];

        chunks = [ ".swell_recent_path" "Recent" "RecentFX" "nag" "reasamplomatic" ];
      }

      { name = "reaper-reginfo2.ini"; settings = [ "uss" ]; chunks = []; }
    ];

    cacheFiles = [ "recentfx" "fxtags" "vstplugins64" "jsfx" "extstate" "midihw-linux" "midihw-alsa" "wndpos" "vstshells64" ];

    # Shortcuts: map&concat
    mapLines = func: data: concatStringsSep "\n" (map func data);

    # Shortcuts: copy file if it exists
    copyExisting = from: to: ''[[ -e "${from}" ]] && cp -vf "${from}" "${to}"'';

    # Shortcuts: colored logs
    sequences = { green = "\\033[0;32m"; reset = "\\033[0m"; };
    mkSeqWrap = x: color: ''${color}${x}${sequences.reset}'';
    mkLog = x: ''echo -e "[${mkSeqWrap "!" sequences.green}] ${mkSeqWrap x sequences.green}"'';

    systemToRepo = /* bash */ ''
      ${mkLog "Copying reaper settings to the repo..."}
      CONFIGS="${files}/configs"
      cp -vf $HOME/.config/REAPER/*.ini "$CONFIGS"

      ${mkLog "Copying timestamp to the repo..."}
      ${copyExisting "$HOME/.config/REAPER/nixtimestamp" "$CONFIGS"}

      ${mkLog "Removing cache files..."}
      ${mapLines (x: "rm -vf $CONFIGS/reaper-${x}.ini") cacheFiles}

      ${mkLog "Making copies of private files..."}
      ${mapLines (x: ''cp -vf "$CONFIGS/${x.name}" "$CONFIGS/.priv-${x.name}"'') privateFiles}
      ${mkLog "Obfuscating private files..."}
      ${obfuscateFiles}
    '';

    obfuscateFiles = let
      settingQuery = filename: setting: ''sed -i -E "/${setting}=/s/=.+/=/g" "$CONFIGS/${filename}"'';
      chunkQuery = filename: chunk: ''sed -i "/^\[${chunk}\]/,/^\[/ s/=.*$/=/" "$CONFIGS/${filename}"'';

      mapQuery = filename: query: list: mapLines (x: query filename x) list;

      mapFileSettings = file: mapQuery file.name settingQuery file.settings;
      mapFileChunks = file: mapQuery file.name chunkQuery file.chunks;
      mapFile = file: concatStringsSep "\n" [ "set -x" (mapFileSettings file) (mapFileChunks file) "set +x" ];
    in mapLines mapFile privateFiles;

    repoToSystem = /* bash */ ''
      ${mkLog "Copying reaper settings from the repo..."}
      cp -vf "${files}"/configs/*.ini "$HOME/.config/REAPER/"

      ${mkLog "Copying private files if any..."}
      ${
        mapLines
        (x: copyExisting "${files}/configs/.priv-${x.name}" "$HOME/.config/REAPER/${x.name}")
        privateFiles
      }

      ${mkLog "Updating the timestamp..."}
      ${copyExisting "${files}/configs/nixtimestamp" "$HOME/.config/REAPER/"}
    '';
  in pkgs.wrapWine rec {
    name = "reaper";
    executable = "${pkgs.reaper}/bin/reaper";

    wine = winePkg;

    # FIXME: dxvk breaks pitchproof, dxvk fixes cab-lab :/
    tricks = [ "mfc42" "vcrun2022" "dxvk" ];

    isWinBin = false;

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
        mapLines mkData cfg.data;

      regScript = mapLines (x: /* bash */ ''
        wine regedit ${x}
      '') cfg.regFiles;

      script = concatStringsSep "\n" [
        (mkLog "Copying data...")
        dataScript

        "set -x"

        (mkLog "Applying reg files...")
        regScript

        "set +x"
      ];
    in script;

    preScript = ''
      # Read timestamps
      REPOSTAMP=`cat "${files}/configs/nixtimestamp" 2>/dev/null || echo "1"`
      SYSTEMSTAMP=`cat "$HOME/.config/reaper/nixtimestamp" 2>/dev/null || echo "0"`

      # note: if the timestamps are equal,
      #       then reaper maybe was forcibly terminated,
      #       so we should execute `postScript` hook to recover

      if [ "$REPOSTAMP" -gt "$SYSTEMSTAMP" ]; then
        ${repoToSystem}
      else
        ${postScript}
      fi
    '';

    postScript = ''
      # Update the timestamp
      echo $EPOCHSECONDS > "$HOME/.config/REAPER/nixtimestamp"

      ${systemToRepo}
    '';
  };
in {
  imports = [
    inputs.musnix.nixosModules.musnix

    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations

    (import ./options.nix { inherit files; })

    ./rt.nix
    ./packages.nix
    ./theme.nix
    ./jsfx.nix
    ./reascripts.nix
    ./sws.nix
  ];

  config = mkIf cfg.enable {
    home-manager.users.${user} = { lib, ... }: {
      home.packages = [ reaper-wrapped reaper-yabridge reaper-yabridgectl ];

      home.file.".config/yabridgectl/config.toml".text = ''
        plugin_dirs = [${concatStringsSep ", " (map (x: "\"${x}\"") cfg.plugins)}, "/home/${user}/.wplugs"]
      '';

      # Do not isolate VST2 plugins
      home.file.".vst/yabridge/yabridge.toml".text = ''
        ["*"]
        group = "all"
      '';

      home.activation.yabridge-sync = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD ${reaper-yabridgectl}/bin/yabridgectl sync -p -n $VERBOSE_ARG
      '';
    };

    # TODO: gc deletes plugins
    # TODO: link files via hm
    # TODO: .wine-nix/reaper/{regs, data, plugins}
    # TODO: prefix without dxvk?
  };
}

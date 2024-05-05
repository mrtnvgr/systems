{ inputs, pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types concatStringsSep;

  cfg = config.modules.desktop.apps.reaper;

  files = "${config.flakePath}/modules/desktop/apps/reaper";

  winePkg = inputs.nix-gaming.packages.${pkgs.system}.wine-tkg;
  yabridge-fixed = pkgs.yabridge.override { wine = winePkg; };
  yabridgectl-fixed = pkgs.yabridgectl.override { wine = winePkg; };

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

    cacheFiles = [ "recentfx" "fxtags" "vstplugins64" "jsfx" "extstate" "midihw-linux" "midihw-alsa" "wndpos" ];

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

    tricks = [ "mfc42" "vcrun2019" ];

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
          DSTPATH="$HOME/.wine-nix/reaper/drive_c/${x.path}"
          mkdir --mode=755 -pv "`dirname "$DSTPATH"`"
          ${getCopyMethod x} -vf "${x.src}" "$DSTPATH"
          chmod -Rcf 755 "$DSTPATH"
        '';
      in
        concatStringsSep "\n" (map mkData cfg.data);

      regScript = concatStringsSep "\n" (map (x: /* bash */ ''
        wine regedit ${x}
      '') cfg.regFiles);

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

  arch = pkgs.stdenv.targetPlatform.linuxArch;
in {
  imports = [
    inputs.musnix.nixosModules.musnix

    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  options.modules.desktop.apps.reaper = {
    enable = mkEnableOption "reaper";

    plugins = mkOption {
      type = with types; listOf path;
      default = [
        # Pitchproof by Aegean Music
        (pkgs.fetchzip {
          url = "https://aegeanmusic.com/sitedownload/pitchproof.zip";
          hash = "sha256-tJWPP3QTmwWxOTuMvwi4OxM3lArGN8GoqU0/3G+cnYY=";
          stripRoot = false;
        } + "/pitchproof${if arch == "x86_64" then "-x64" else ""}.dll")
      ];
    };

    data = mkOption {
      type = types.listOf (types.submodule {
        options = {
          src = mkOption { type = types.str; };
          path = mkOption { type = types.str; };
          symlink = mkOption { type = types.bool; default = true; };
          linkContents = mkOption { type = types.bool; default = false; };
        };
      });

      default = [
        # Neural DSP (Stock presets)
        {
          src = "${inputs.ndsp-presets}";
          path = "ProgramData/Neural DSP";
          linkContents = true;
        }

        # Neural DSP: Archetype Gojira (User presets)
        {
          src = "${files}/presets/gojira";
          path = "ProgramData/Neural DSP/Archetype Gojira/User";
        }

        # Neural DSP: Archetype Nolly (User presets)
        {
          src = "${files}/presets/nolly";
          path = "ProgramData/Neural DSP/Archetype Nolly/User";
        }

        # Neural DSP: OMEGA Ampworks Granophyre (User presets)
        {
          src = "${files}/presets/granophyre";
          path = "ProgramData/Neural DSP/OMEGA Ampworks Granophyre/User";
        }
      ];
    };

    regFiles = mkOption {
      type = with types; listOf path;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = { lib, ... }: {
      home.packages = [ reaper-wrapped yabridge-fixed ];

      # TODO: remove .wvst* lookups
      home.file.".config/yabridgectl/config.toml".text = ''
        plugin_dirs = [${concatStringsSep ", " (map (x: "\"${x}\"") cfg.plugins)}, "/home/${user}/.wvst3", "/home/${user}/.wvst"]
      '';

      # Do not isolate VST2 plugins
      home.file.".vst/yabridge/yabridge.toml".text = ''
        ["*"]
        group = "all"
      '';

      home.activation.yabridge-sync = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD ${yabridgectl-fixed}/bin/yabridgectl sync -p -n $VERBOSE_ARG
      '';

      # Reaper MIDI notes colormap
      home.file.".config/REAPER/Data/color_maps/default.png".source = pkgs.fetchurl {
        url = "https://i.imgur.com/Ca0JhRF.png";
        hash = "sha256-FSANQn2V4TjYUvNr4UV1qUhOSeUkT+gsd1pPj4214GY=";
      };

      # TODO: link reapertips theme

      # SWS Extension
      home.file.".config/REAPER/UserPlugins/reaper_sws-${arch}.so".source = "${pkgs.reaper-sws-extension}/UserPlugins/reaper_sws-${arch}.so";
      home.file.".config/REAPER/Scripts/sws_python.py".source = "${pkgs.reaper-sws-extension}/Scripts/sws_python.py";
      home.file.".config/REAPER/Scripts/sws_python64.py".source = "${pkgs.reaper-sws-extension}/Scripts/sws_python64.py";

      # JSFX Plugins
      home.file.".config/REAPER/Effects/Geraint".source = inputs.jsfx-geraint;
      home.file.".config/REAPER/Effects/ReJJ".source = inputs.jsfx-rejj;
      home.file.".config/REAPER/Effects/chkhld".source = inputs.jsfx-chkhld;

      # FIXME: https://github.com/NixOS/nix/pull/9053
      home.file.".config/REAPER/Effects/Tale".source = pkgs.fetchzip {
        url = "https://www.taletn.com/reaper/mono_synth/Tale_20230711.zip";
        hash = "sha256-3qfOgAsQR91hXXah44PrLITNS44a5VMitbIVKZ4E9y4=";
        stripRoot = false;
      } + "/Effects/Tale";

      # Reaper Scripts
      # note: you must import them in the REAPER Actions menu
      # reaper-kb.ini: `SCR 4 0 RS{hash?} "{Script Name}" {relative_path}`

      # MK Slicer, MK Shaper
      home.file.".config/REAPER/Scripts/cool/MKSlicer.lua".source = "${inputs.reascripts}/Items Editing/cool_MK Slicer.lua";
      home.file.".config/REAPER/Scripts/cool/MKShaper.lua".source = "${inputs.reascripts}/Envelopes/cool_MK ShaperStutter.lua";
    };

    # Real-time audio tweaks
    musnix.enable = true;
    musnix.kernel.packages = pkgs.linuxPackages_latest_rt;

    # Provided by nix-gaming modules
    services.pipewire.lowLatency.enable = true;
    programs.steam.platformOptimizations.enable = true;

    # note: workaround for fufexan/nix-gaming#173
    security.pam.loginLimits = [{
      domain = user;
      item = "nice";
      type = "hard";
      value = "-20";
    }];

    environment.systemPackages = with pkgs; [
      # FIXME: neuralnote
      neural-amp-modeler-lv2
    ];

    # TODO: split this :)
  };
}

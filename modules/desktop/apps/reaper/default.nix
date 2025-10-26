{ inputs, pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf concatStringsSep;

  cfg = config.modules.desktop.apps.reaper;

  winePkg = inputs.nixpkgs-wine.legacyPackages.${pkgs.system}.wineWowPackages.stagingFull;

  reaper-yabridge = pkgs.yabridge.override { wine = winePkg; };
  reaper-yabridgectl = pkgs.yabridgectl.override { wine = winePkg; };

  reaper-wrapped = let
    # Shortcuts: map&concat
    mapLines = func: data: concatStringsSep "\n" (map func data);

    # Shortcuts: colored logs
    sequences = { green = "\\033[0;32m"; reset = "\\033[0m"; };
    mkSeqWrap = x: color: ''${color}${x}${sequences.reset}'';
    mkLog = x: ''echo -e "[${mkSeqWrap "!" sequences.green}] ${mkSeqWrap x sequences.green}"'';
  in pkgs.wrapWine {
    name = "reaper";
    executable = "${pkgs.reaper}/bin/reaper";

    wine = winePkg;

    tricks = [ "mfc42" "vcrun2022" "dxvk" "gdiplus" ];

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

    preScript = /* bash */ ''
      ${mkLog "Running preRun hook..."}
      ${cfg.extraPreRunScript}
    '';
  };
in {
  imports = [
    inputs.musnix.nixosModules.musnix

    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations

    ./options.nix
    ./rt.nix
    ./packages.nix
    ./theme.nix
    ./reascripts.nix
    ./avoid-gc.nix
  ];

  config = mkIf cfg.enable {
    home-manager.users.${user} = { lib, ... }: {
      home.packages = [ reaper-wrapped reaper-yabridge reaper-yabridgectl ];

      home.file.".config/yabridgectl/config.toml".text = let
        plugins = cfg.plugins ++ [ "/home/${user}/.wplugs" ];
      in ''
        plugin_dirs = [${concatStringsSep ", " (map (x: "\"${x}\"") plugins)}]
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

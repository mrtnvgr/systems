{ config, pkgs, lib, ... }: let
  # TODO: Xorg support
  inherit (lib) mkIf mkOption mkOptionType types hasPrefix removePrefix;
  inherit (builtins) isString concatStringsSep;

  wallpapers = config.modules.desktop.theme.wallpapers;
  palette = config.colorScheme.palette;

  # Either hex color or image
  sb = map (x: if isString x then ''"--color=#${x}"'' else ''"-i ${x}"'') wallpapers;

  chwl = pkgs.writeShellScriptBin "chwl" /* bash */ ''
    STATEFILE=/tmp/.wallstate
    STATE=`cat $STATEFILE 2>/dev/null`

    while :; do
      RANDOMCMD=`shuf -n1 -e -- ${concatStringsSep " " sb}`
      [ "$RANDOMCMD" = "$STATE" ] || break
    done

    echo "$RANDOMCMD" > $STATEFILE

    PIDS=`pidof swaybg 2>/dev/null`
    (${pkgs.swaybg}/bin/swaybg $RANDOMCMD &>/dev/null) &
    (sleep 0.3s && kill $PIDS &>/dev/null) &
  '';

  # Credits: Misterio77/nix-colors! Thx <3
  hexColorType = mkOptionType {
    name = "hex-color";
    descriptionClass = "noun";
    description = "RGB color in hex format";
    check = x: isString x && !(hasPrefix "#" x);
  };

  cfg = config.modules.desktop;
in {
  options.modules.desktop.theme.wallpapers = mkOption {
    type = with types; nullOr (
      listOf (either
        package
        (coercedTo str (removePrefix "#") hexColorType)
      )
    );
    default = null;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ chwl ];
  };
}

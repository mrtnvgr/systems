{ inputs, pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  inherit (pkgs) writeShellScriptBin;

  cfg = config.modules.desktop.apps.renoise;

  # TIP: use 48000hz, 2 periods for "default" device if ALSA with Pipewire is used
in {
  options.modules.desktop.apps.renoise = {
    enable = mkEnableOption "renoise";
    releasePath = mkOption { type = with types; nullOr path; default = null; };
    version = mkOption { type = types.str; default = "V3.5.1"; };
  };

  config = mkIf cfg.enable {
    assertions = [ jackAssertion ];

  config = mkIf cfg.enable {
    environment.systemPackages = let
      renoise = if (cfg.releasePath != null) then pkgs.renoise.override { releasePath = cfg.releasePath; } else pkgs.renoise;
      renoise-jack = writeShellScriptBin "renoise" "exec ${pkgs.pipewire.jack}/bin/pw-jack ${renoise}/bin/renoise";
    in [ renoise-jack pkgs.rubberband ];

    # TODO: wait for https://github.com/nix-community/home-manager/issues/3090
    # look into commit history, revert tool support removal
    home-manager.users.${user} = let
      renoisePath = ".config/Renoise/${cfg.version}";
    in {
      home.file."${renoisePath}/Themes/catppuccin".source = "${inputs.catppuccin-renoise}/themes";
    };
  };
}

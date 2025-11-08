# TIP: use 48000hz, 2 periods for "default" device if ALSA with PipeWire is used

{ inputs, pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  inherit (pkgs) writeShellScriptBin;

  cfg = config.modules.desktop.audio.daws.renoise;
in {
  options.modules.desktop.audio.daws.renoise = {
    enable = mkEnableOption "Renoise";

    releasePath = mkOption { type = with types; nullOr path; default = null; };
    version = mkOption { type = types.str; default = "V3.5.1"; }; # !!!
  };

  config = mkIf cfg.enable {
    environment.systemPackages = let
      renoise = if (cfg.releasePath != null) then pkgs.renoise.override { releasePath = cfg.releasePath; } else pkgs.renoise;

      jackdCfg = config.services.jack.jackd;
      pipewireCfg = config.services.pipewire;
      isJackEnabled = jackdCfg.enable || (pipewireCfg.enable && pipewireCfg.jack.enable);

      wrapWithPWJack = name: executable:
        writeShellScriptBin name "exec ${pkgs.pipewire.jack}/bin/pw-jack ${executable}";

      renoiseWrapped = if isJackEnabled then wrapWithPWJack "renoise" "${renoise}/bin/renoise" else renoise;
    in [ renoiseWrapped ];

    # Fix sudden Renoise disconnections from JACK
    # services.pipewire.extraConfig.jack."99-client-timeout" = {
    #   "jack.properties"
    # };
    services.jack.jackd.extraOptions = [ "--timeout 1000" ];

    # TODO: wait for https://github.com/nix-community/home-manager/issues/3090
    # look into commit history, revert tool support removal
    home-manager.users.${user} = let
      renoisePath = ".config/Renoise/${cfg.version}";
    in {
      home.file."${renoisePath}/Themes/catppuccin".source = "${inputs.catppuccin-renoise}/themes";
    };
  };
}

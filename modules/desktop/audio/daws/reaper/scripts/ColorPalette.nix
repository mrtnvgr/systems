{ inputs, lib, config, pkgs, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;

  script = pkgs.stdenvNoCC.mkDerivation {
    name = "ColorPalette-patched";

    src = "${inputs.reascripts}/Various/rodilab_Color palette.lua";

    dontUnpack = true;

    installPhase = ''
      cp "$src" "$out"

      substituteInPlace "$out" \
        --replace-fail "Arial" "Liberation Sans"
    '';
  };
in {
  modules.desktop.audio.daws.reaper = lib.mkIf cfg.enable {
    scripts.ColorPalette = {
      source = script;
      key = "47";
    };

    config."reaper-extstate.ini" = /* dosini */ ''
      [RODILAB_Color_palette]
      number_x=12
      palette_y=1
      user_y=0
      background=false
    '';

    extensions = {
      reaimgui.enable = true;
      js_ReaScriptAPI.enable = true;
      sws.enable = true;
    };
  };
}

{ inputs, lib, config, pkgs, user, ... }: let
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
  home-manager.users.${user} = lib.mkIf cfg.enable {
    programs.reanix = {
      scripts.ColorPalette = {
        source = script;
        key = "1 67"; # C
      };

      extraConfig."reaper-extstate.ini" = /* dosini */ ''
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
  };
}

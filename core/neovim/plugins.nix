{ pkgs, config, user, ... }:
let
  inherit (config.colorScheme) palette;
  mkStandout = color: { fg = "#${color}"; bold = true; italic = true; };
  mkMegaStandout = color: mkStandout color // { underline = true; };
in {
  home-manager.users.${user} = {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [
        # Smart indentation
        indent-o-matic
      ];

      # Comments
      plugins.comment.enable = true;
      highlightOverride = with palette; {
        "DiagnosticInfo" = mkStandout sky;
        "DiagnosticHint" = mkStandout violet;
        "DiagnosticWarn" = mkStandout yellow;
        "DiagnosticError" = mkStandout red;

        "TODO".link = "DiagnosticInfo";

        "@constant.comment".fg = "#${pink}";

        "SpellBad" = mkMegaStandout red;
        "SpellCap".link = "SpellBad";
        "SpellLocal".link = "SpellBad";
        "SpellRare".link = "SpellBad";
      };
    };
  };
}

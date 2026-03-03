# Catppuccin has support for almost every color highlight
# Picked catppuccin? => Using catppuccin, duh! ;p
# Not? => Using catppuccin and overriding its colors, mapping rare ones to fg

{ config, user, lib, ... }: let
  cfg = config.modules.desktop.apps.neovim;

  colorscheme = config.modules.desktop.theme.colorscheme;
  notCatppuccin = colorscheme.slug != "catppuccin";

  overrideMap = with colorscheme.palette; {
    rosewater = text;
    flamingo  = text;
    pink      = pink;
    mauve     = purple;
    red       = red;
    maroon    = red;
    peach     = orange;
    yellow    = yellow;
    green     = green;
    teal      = blue;
    sky       = blue;
    sapphire  = blue;
    blue      = blue;
    lavender  = blue;
    text      = text;
    subtext1  = gray8;
    subtext0  = gray7;
    overlay2  = gray6;
    overlay1  = gray5;
    overlay0  = gray4;
    surface2  = gray3;
    surface1  = gray2;
    surface0  = gray;
    base      = background;
    mantle    = void;
    crust     = void;
  };

  overrides = builtins.mapAttrs (_: x: "#${x}") overrideMap;
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf (cfg.enable && notCatppuccin) {
    colorschemes.catppuccin.settings.color_overrides.all = overrides;
  };
}

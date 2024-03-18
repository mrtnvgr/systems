let
  mkColorscheme = p:
    let
      file = import p;

      named = file.palette;
      basePalette = with palette; {
        base00 = background;
        base01 = darkness;
        base02 = gray;
        base03 = gray2;
        base04 = gray3;
        base05 = text;
        base06 = fawn;
        base07 = lavender;
        base08 = red;
        base09 = orange;
        base0A = yellow;
        base0B = green;
        base0C = teal;
        base0D = blue;
        base0E = violet;
        base0F = skin;
      };

      palette = named // basePalette;
    in
      file // { palette = palette; };
in {
  catppuccin = mkColorscheme ./catppuccin.nix;
}

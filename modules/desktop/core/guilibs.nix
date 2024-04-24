{ inputs, pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop;
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
  palette = config.colorScheme.palette;

  # TODO: bibata-custom = pkgs.bibata-cursors.overrideAttrs (srcAttrs: {
  #   buildInputs = with pkgs; (srcAttrs.buildInputs or []) ++ [ cbmp ];
  #
  #   buildPhase = ''
  #     cbmp -d "svg/modern" -o "bitmaps/Bibata-Custom" -bc "#${palette.background}" -oc "#${palette.text}" -wc "#${palette.background}"
  #     ctgen build.toml -p x11 -d "bitmaps/Bibata-Custom" -n "Bibata-Custom" -c "Custom colored, rounded edge Bibata cursors."
  #   '';
  # });
in {
  config = mkIf cfg.enable {
    home-manager.users."${user}" = {
      gtk = {
        enable = true;

        theme = {
          name = config.colorScheme.slug;
          package = nix-colors-lib.gtkThemeFromScheme {
            scheme = config.colorScheme;
          };
        };

        gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
        gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
      };

      qt = {
        enable = true;
        platformTheme.name = "gtk";
      };

      home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";

        size = 16;

        x11.enable = true;
        gtk.enable = true;
      };
    };

    # https://github.com/nix-community/home-manager/issues/3113
    programs.dconf.enable = true;
  };
}

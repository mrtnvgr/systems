{ inputs, pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop;
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
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
        package = pkgs.catppuccin-cursors.macchiatoPink;
        name = "catppuccin-macchiato-pink-cursors";

        size = 24;

        x11.enable = true;
        gtk.enable = true;
      };
    };

    # https://github.com/nix-community/home-manager/issues/3113
    programs.dconf.enable = true;
  };
}

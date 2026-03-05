{ lib, config, user, ... }: let
  cfg = config.modules.desktop;
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      gtk = {
        enable = true;
        colorScheme = "dark";

        theme.name = "Adwaita";
        iconTheme.name = "Adwaita";
      };
    };

    # https://github.com/nix-community/home-manager/issues/3113
    programs.dconf.enable = true;
  };
}

{ pkgs, lib, config, user, ... }: let
  cfg = config.modules.desktop.audio.daws.reaper;
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      # Reaper MIDI notes colormap
      home.file.".config/REAPER/Data/color_maps/default.png".source = pkgs.fetchurl {
        url = "https://i.imgur.com/Ca0JhRF.png";
        hash = "sha256-FSANQn2V4TjYUvNr4UV1qUhOSeUkT+gsd1pPj4214GY=";
      };

      # TODO: link reapertips theme
      # TODO: generate based on colorscheme colors
    };
  };
}

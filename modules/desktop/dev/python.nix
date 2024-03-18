{ pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  pypkgs = ps: with ps; [
    # Essentials
    requests
    datetime

    # Image processing
    pillow

    # Web scraping
    beautifulsoup4

    # Machine learning
    numpy
    matplotlib
    pandas
    nltk
    natasha

    # FIXME: pygame
    # FIXME: pyppeteer
  ];

  cfg = config.modules.desktop.dev.python;
in
{
  options.modules.desktop.dev.python.enable = mkEnableOption "python";
  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [
        (pkgs.python3.withPackages pypkgs)
      ];
    };
  };
}

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
    lxml

    # Notebooks
    # jupyter
    # ipython

    # Machine learning
    # numpy
    # matplotlib
    # pandas
    # nltk
    # natasha
    # pytorch
    # transformers
    # scikit-learn

    # pygame
    # pyppeteer

    django
    django-tables2
    pandas
    openpyxl
  ];

  cfg = config.modules.desktop.dev.python;
in
{
  options.modules.desktop.dev.python.enable = mkEnableOption "python";
  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ (pkgs.python3.withPackages pypkgs) ];
    };
  };
}

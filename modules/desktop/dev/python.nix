{ pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  # TODO: https://github.com/NixOS/nixpkgs/pull/298964
  # natashaPkgs = import (pkgs.fetchFromGitHub {
  #   owner = "mrtnvgr";
  #   repo = "nixpkgs";
  #   rev = "fix/razdel";
  #   hash = "sha256-7hOemLE4VditQUd4FrybCaV57RkJIOtUf6rlpDzJvrc=";
  # }) { system = pkgs.stdenv.system; };
  # natasha = natashaPkgs.python3Packages.natasha;

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

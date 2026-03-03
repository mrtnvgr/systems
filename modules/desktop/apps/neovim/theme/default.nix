{ config, pkgs, lib, user, ... }: let
  # TODO: package to nixpkgs
  bg-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "bg-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "typicode";
      repo = "bg.nvim";
      rev = "85da2c68409820466753b50c2e6f699517778a17";
      hash = "sha256-s9m5OgQpehrkIU6bWj70RDEqvSzlxzpih8sRuQrtdC0=";
    };
  };
in {
  imports = [
    ./transparency.nix
    ./overrides.nix
  ];

  home-manager.users.${user}.programs.nixvim = lib.mkIf config.modules.desktop.apps.neovim.enable {
    colorschemes.catppuccin.enable = true;

    extraPlugins = [ bg-nvim ];
  };
}

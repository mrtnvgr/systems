{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wine.url = "github:nixos/nixpkgs/b73c2221a46c13557b1b3be9c2070cc42cf01eb3";

    # >=========================================================<
    # > Unmerged PRs
    # >=========================================================<
    nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";

    nixpkgs-patch-convertwithmoss = {
      url = "https://github.com/NixOS/nixpkgs/pull/470158.patch";
      flake = false;
    };

    nixpkgs-patch-hamburger = {
      url = "https://github.com/NixOS/nixpkgs/pull/468672.patch";
      flake = false;
    };

    nixpkgs-patch-nils-k1v = {
      url = "https://github.com/NixOS/nixpkgs/pull/468448.patch";
      flake = false;
    };

    nixpkgs-patch-spectralsuite = {
      url = "https://github.com/NixOS/nixpkgs/pull/463653.patch";
      flake = false;
    };

    nixpkgs-patch-cstop = {
      url = "https://github.com/NixOS/nixpkgs/pull/463428.patch";
      flake = false;
    };

    nixpkgs-patch-socalabs-loser-ports = {
      url = "https://github.com/NixOS/nixpkgs/pull/462546.patch";
      flake = false;
    };

    nixpkgs-patch-socalabs-voc = {
      url = "https://github.com/NixOS/nixpkgs/pull/462475.patch";
      flake = false;
    };

    nixpkgs-patch-socalabs-mverb = {
      url = "https://github.com/NixOS/nixpkgs/pull/462464.patch";
      flake = false;
    };

    nixpkgs-patch-socalabs-wavetable = {
      url = "https://github.com/NixOS/nixpkgs/pull/462243.patch";
      flake = false;
    };

    nixpkgs-patch-socalabs-other-bundle = {
      url = "https://github.com/NixOS/nixpkgs/pull/462236.patch";
      flake = false;
    };

    nixpkgs-patch-socalabs-papu = {
      url = "https://github.com/NixOS/nixpkgs/pull/461897.patch";
      flake = false;
    };

    nixpkgs-patch-socalabs-piano = {
      url = "https://github.com/NixOS/nixpkgs/pull/461894.patch";
      flake = false;
    };

    nixpkgs-patch-socalabs-sn76489 = {
      url = "https://github.com/NixOS/nixpkgs/pull/461853.patch";
      flake = false;
    };

    nixpkgs-patch-socalabs-rp2a03 = {
      url = "https://github.com/NixOS/nixpkgs/pull/461837.patch";
      flake = false;
    };

    nixpkgs-patch-socalabs-organ = {
      url = "https://github.com/NixOS/nixpkgs/pull/461829.patch";
      flake = false;
    };

    nixpkgs-patch-auburn-sounds-inner-pitch = {
      url = "https://github.com/NixOS/nixpkgs/pull/461472.patch";
      flake = false;
    };

    nixpkgs-patch-wildergarden-maim = {
      url = "https://github.com/NixOS/nixpkgs/pull/461467.patch";
      flake = false;
    };

    nixpkgs-patch-reevr = {
      url = "https://github.com/NixOS/nixpkgs/pull/460283.patch";
      flake = false;
    };

    nixpkgs-patch-filtr = {
      url = "https://github.com/NixOS/nixpkgs/pull/460273.patch";
      flake = false;
    };

    nixpkgs-patch-gate12 = {
      url = "https://github.com/NixOS/nixpkgs/pull/460260.patch";
      flake = false;
    };

    nixpkgs-patch-time12 = {
      url = "https://github.com/NixOS/nixpkgs/pull/460099.patch";
      flake = false;
    };

    nixpkgs-patch-sfizz-ui = {
      url = "https://github.com/NixOS/nixpkgs/pull/457744.patch";
      flake = false;
    };
    # >=========================================================<

    # My repo of custom packages and functions
    mrtnvgr = {
      url = "github:mrtnvgr/nurpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    generators.url = "github:nix-community/nixos-generators";
    generators.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:Misterio77/nix-colors";

    nixvim.url = "github:nix-community/nixvim";

    reanix = {
      url = "github:mrtnvgr/reanix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.mrtnvgr.follows = "mrtnvgr";
    };

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    schizofox.url = "github:schizofox/schizofox";

    nix-gaming.url = "github:fufexan/nix-gaming";

    reascripts.url = "github:ReaTeam/ReaScripts";
    reascripts.flake = false;

    catppuccin-renoise.url = "github:catppuccin/renoise";
    catppuccin-renoise.flake = false;
  };

  outputs = { nixpkgs-patcher, ... } @ inputs:
    let
      colorschemes = import ./colorschemes;

      mkSystem = user: hostname:
        nixpkgs-patcher.lib.nixosSystem {
          nixpkgsPatcher.nixpkgs = inputs.nixpkgs;

          modules = [
            ./core

            ./modules

            ./hosts/${hostname}/hardware.nix
            ./hosts/${hostname}
          ];

          specialArgs = { inherit inputs colorschemes user hostname; };
        };
    in
    {
      nixosConfigurations = {
        # <hostname> = mkSystem <username> <hostname>;

        # Desktops
        nixie = mkSystem "user" "nixie";
        thlix = mkSystem "user" "thlix";
        minix = mkSystem "user" "minix";

        # Servers
        cloud = mkSystem "user" "cloud";
      };
    };
}

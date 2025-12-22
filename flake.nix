{
  inputs = {
    nixpkgs.url = "github:mrtnvgr/nixpkgs-fork/channel/future";
    nixpkgs-wine.url = "github:nixos/nixpkgs/b73c2221a46c13557b1b3be9c2070cc42cf01eb3";

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

  outputs = { nixpkgs, ... } @ inputs:
    let
      colorschemes = import ./colorschemes;

      mkSystem = user: hostname:
        nixpkgs.lib.nixosSystem {
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

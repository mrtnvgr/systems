{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wine.url = "github:nixos/nixpkgs/b73c2221a46c13557b1b3be9c2070cc42cf01eb3";

    generators.url = "github:nix-community/nixos-generators";
    generators.inputs.nixpkgs.follows = "nixpkgs";

    mrtnvgr = {
      url = "github:mrtnvgr/nurpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    nix-colors.url = "github:Misterio77/nix-colors";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    schizofox.url = "github:schizofox/schizofox";

    musnix.url = "github:musnix/musnix";

    nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";

    ndsp-presets.url = "github:musicprodcdn/presets";
    ndsp-presets.flake = false;

    eggs.url = "https://github.com/mrtnvgr/eggs/releases/download/master/built.zip";
    eggs.flake = false;

    blog.url = "github:mrtnvgr/blog";
    blog.flake = false;

    jsfx-geraint.url = "github:musicprodcdn/geraintluff-jsfx";
    jsfx-geraint.flake = false;

    jsfx-rejj.url = "github:musicprodcdn/ReJJ-jsfx";
    jsfx-rejj.flake = false;

    jsfx-chkhld.url = "github:musicprodcdn/chkhld-jsfx";
    jsfx-chkhld.flake = false;

    reascripts.url = "github:ReaTeam/ReaScripts";
    reascripts.flake = false;
  };

  outputs = { nixpkgs, ... } @ inputs:
    let
      colorschemes = import ./colorschemes;

      mkSystem = user: hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs colorschemes user hostname; };
          modules = [
            ./core

            ./modules

            ./hosts/${hostname}/hardware.nix
            ./hosts/${hostname}
          ];
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

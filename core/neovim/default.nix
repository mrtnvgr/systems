{ inputs, pkgs, config, user, ... }: {
  home-manager.users.${user} = {
    imports = [ inputs.nixvim.homeManagerModules.nixvim ];

    programs.nixvim = {
      enable = true;
      package = pkgs.neovim-nightly;

      viAlias = true;
      vimAlias = true;
      defaultEditor = true;

      luaLoader.enable = true;
    };
  };

  imports = [
    ./options.nix
    ./autocmds.nix
    ./keymaps.nix
    ./theme.nix
    ./plugins.nix
  ];
}

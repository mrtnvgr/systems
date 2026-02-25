{ inputs, user, ... }: {
  home-manager.users.${user} = {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
      defaultEditor = true;

      performance.byteCompileLua = {
        enable = true;
        initLua = true;
        luaLib = true;
        nvimRuntime = true;
        plugins = true;
      };
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

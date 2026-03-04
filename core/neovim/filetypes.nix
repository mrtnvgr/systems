{ user, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    filetype.extension."pd_lua" = "lua";
  };
}

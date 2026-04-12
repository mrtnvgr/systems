{ pkgs, user, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      # Smart indentation
      indent-o-matic
    ];
  };
}

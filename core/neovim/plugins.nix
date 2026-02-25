{ pkgs, user, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    plugins.comment.enable = true;

    extraPlugins = with pkgs.vimPlugins; [
      # Smart indentation
      indent-o-matic
    ];
  };
}

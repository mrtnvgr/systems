{ pkgs, user, ... }: {
  environment.systemPackages = with pkgs; [ github-cli git-lfs git-crypt ];

  home-manager.users.${user} = {
    programs.git = {
      enable = true;
      settings = {
        user.name = "mrtnvgr";
        user.email = "martynovegorOF@yandex.ru";

        pull.rebase = true;
        init.defaultBranch = "master";
      };

      signing = {
        signByDefault = true;
        key = "6FADDB43D5A5FE52683509435B3379E981EF48B1";
      };
    };
  };
}

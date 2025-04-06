{ pkgs, user, ... }: {
  home-manager.users.${user} = {
    home.packages = with pkgs; [ github-cli git-lfs git-crypt ];
    programs.git = {
      enable = true;
      userName = "mrtnvgr";
      userEmail = "martynovegorOF@yandex.ru";

      aliases = {
        ammit = "commit -a --amend --no-edit";
        undo = "reset HEAD~1";
      };

      signing = {
        signByDefault = true;
        key = "6FADDB43D5A5FE52683509435B3379E981EF48B1";
      };

      extraConfig = {
        pull.rebase = true;
        init.defaultBranch = "master";
      };
    };
  };
}

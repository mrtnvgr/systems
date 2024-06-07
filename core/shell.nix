{ pkgs, user, ... }: let
  fixperms = pkgs.writeShellScriptBin "fixperms" ''
    find "$1" -type d -exec chmod 755 {} +
    find "$1" -type f -exec chmod 644 {} +
  '';
in {
  home-manager.users.${user} = {
    programs.bash = {
      enable = true;

      initExtra = ''
        PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
      '';

      shellAliases = {
        perm = "stat -c \"%a %n\"";

        # Better defaults
        rsync = "rsync -zvhP";
        rsync-mirror-fat = "rsync -r --update --delete --size-only";
      };
    };

    home.packages = [ fixperms ];
  };
}

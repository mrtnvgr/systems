{ inputs, config, user, hostname, ... }:
let
  inherit (inputs.nix-colors.lib.conversions) hexToRGBString;

  mkHexColor = x: ''\e[38;2;${hexToRGBString ";" x}m'';
  reset = ''\e[0m'';

  palette = config.colorScheme.palette;

  icon = with palette;
  # TODO: better way to determine this
  if hostname == "thlix" then
    "${mkHexColor pink}󱊞"
  else if config.modules.desktop.enable then
    "${mkHexColor blue}"
  else
    "";
in {
  home-manager.users.${user} = {
    programs.bash = {
      enable = true;

      # initExtra = ''PS1="${icon} \W ${reset}"'';
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
  };
}

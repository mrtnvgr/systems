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

      initExtra = ''PS1="${icon} \W ${reset}"'';

      shellAliases = {
        perm = "stat -c \"%a %n\"";

        # Better defaults
        rsync = "rsync -zvhP";
        rsync-mirror-fat = "rsync -r --update --delete --size-only";
      };
    };
  };
}

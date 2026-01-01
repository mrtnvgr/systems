{ lib, config, ... }:
let
  cfg = config.modules.desktop;
in {
  options._internals.DELauncher = lib.mkOption {
    type = lib.types.singleLineStr;
    description = "DE/WM launch command";
  };

  config = lib.mkIf cfg.enable {
    environment.loginShellInit = ''
      # Launch WM/DE on TTY1, return to TTY when exiting
      [ "$(tty)" = "/dev/tty1" ] && ${config._internals.DELauncher} >/dev/null
    '';
  };
}

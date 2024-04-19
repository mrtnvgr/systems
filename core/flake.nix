{ user, lib, ... }:
let
  inherit (lib) mkOption types;
in {
  options.flakePath = mkOption {
    type = types.str;
    default = "/home/${user}/.systems";
  };
}

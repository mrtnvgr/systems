{ inputs, config, lib, ... }: {
  # Use flake's inputs system-wide
  # TODO: https://github.com/NixOS/nix/issues/8890

  nix = {
    channel.enable = false;
    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings.flake-registry = "/etc/nix/registry.json";
  };
}

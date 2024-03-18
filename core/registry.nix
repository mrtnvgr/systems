{ inputs, config, lib, user, ... }: {
  # Use flake's inputs system-wide
  # TODO: https://github.com/NixOS/nix/issues/8890
  # TODO: https://github.com/NixOS/nix/pull/8902

  # !!!

  nix = {
    # NOTE: включение этой опции вызывает `nix-path = ` в nix.conf
    #       что из-за неправильных приоритетов значений вызывает баги
    #       (`NIX_PATH` игнорируется в пользу `nix-path = `)
    # NOTE: скорее всего проблема ещё в отсуствии каналов в системе
    channel.enable = false;

    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings.flake-registry = "/etc/nix/registry.json";
  };
}

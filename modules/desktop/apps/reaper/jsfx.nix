{ inputs, pkgs, lib, config, user, ... }: let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.apps.reaper;

  # FIXME: https://github.com/NixOS/nix/pull/9053
  tale = pkgs.fetchzip {
    url = "https://www.taletn.com/reaper/mono_synth/Tale_20230711.zip";
    hash = "sha256-3qfOgAsQR91hXXah44PrLITNS44a5VMitbIVKZ4E9y4=";
    stripRoot = false;
  } + "/Effects/Tale";
in {
  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.file.".config/REAPER/Effects/Geraint".source = inputs.jsfx-geraint;
      home.file.".config/REAPER/Effects/ReJJ".source = inputs.jsfx-rejj;
      home.file.".config/REAPER/Effects/chkhld".source = inputs.jsfx-chkhld;
      home.file.".config/REAPER/Effects/Tale".source = tale;
    };
  };
}

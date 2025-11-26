{ lib, config, user, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.audio.daws.reaper;

  # TODO: https://github.com/NixOS/nixpkgs/pull/464016
  reaimgui-file = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/mrtnvgr/nixpkgs/c2e057c630e0bbc6bd1b7128c9fc1e3b1dea597e/pkgs/by-name/re/reaimgui/package.nix";
    hash = "sha256-vtMCeWvE6rvewva2XFUDvzLx4+jcP2Zz6RvyNYH8sn4=";
  };

  reaimgui = pkgs.callPackage reaimgui-file { };

  scripts = "Scripts/ReaTeam Extensions/API";
in {
  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.file.".config/REAPER/UserPlugins/reaper_imgui-x86_64.so".source = "${reaimgui}/UserPlugins/reaper_imgui-x86_64.so";

      home.file.".config/REAPER/${scripts}/imgui.lua".source = "${reaimgui}/${scripts}/imgui.lua";
      home.file.".config/REAPER/${scripts}/imgui.py".source = "${reaimgui}/${scripts}/imgui.py";
    };
  };
}

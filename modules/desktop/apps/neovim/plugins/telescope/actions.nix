{ config, lib, user, pkgs, ... }: let
  cfg = config.modules.desktop.apps.neovim;

  # TODO: package in nixpkgs, make a PR to nixvim
  actions-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "actions.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "mrtnvgr";
      repo = "actions.nvim";
      rev = "781d1717657f5ab035e5369883b6eb41dc51160e";
      hash = "sha256-U8uBwJpXyTvFXX7SfpNKFihsL2Ezn/i19unaCis7Vq4=";
    };
  };
in {
  home-manager.users.${user}.programs.nixvim = lib.mkIf cfg.enable {
    extraPlugins = [ actions-nvim ];
    extraConfigLua = ''
      local actions = require("actions");
      actions.setup({ actions = actions.stock_actions })
    '';

    plugins.telescope = {
      enabledExtensions = [ "actions" ];
      keymaps."?" = "actions action_list";
    };
  };
}

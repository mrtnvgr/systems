{ config, lib, user, ... }: {
  config = lib.mkIf config.modules.desktop.apps.neovim.enable {
    home-manager.users.${user}.programs.nixvim.plugins = {
      lsp.enable = true;

      lsp.keymaps = {
        lspBuf = {
          K = "hover";
          gD = "references";
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
          "<F2>" = "rename";
          "<F4>" = "code_action";
        };

        diagnostic.gl = "open_float";
      };
    };
  };

  imports = [
    ./completion.nix
    ./snippets.nix
    ./extra.nix

    ./servers/rust.nix
  ];
}

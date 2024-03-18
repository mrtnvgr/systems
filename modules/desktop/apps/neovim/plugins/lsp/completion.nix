{ config, lib, user, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.apps.neovim;
in {
  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.nixvim.plugins.cmp = {
        enable = true;

        settings = {
          completion.completeopt = "menu,menuone,noselect,noinsert";

          formatting.fields = [ "kind" "abbr" ];

          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          snippet.expand = "function(args) require(\"luasnip\").lsp_expand(args.body) end";

          window = {
            completion = {
              border = cfg.border;
              # side_padding = 0;
              col_offset = -5;
            };

            documentation = {
              border = cfg.border;
              max_height = 15;
              max_width = 60;
            };
          };

          mapping = {
            "<CR>" = "cmp.mapping.confirm()";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-e>" = "cmp.mapping.close()";
          };

          performance.max_view_entries = 5;
        };
      };

      programs.nixvim.plugins.lspkind = {
        enable = true;
        mode = "symbol";
        cmp.after = ''
          function(_, _, kind)
            kind.kind = " " .. kind.kind .. " "
            return kind
          end
        '';
      };

      # Invert kinds
      # credits: https://github.com/catppuccin/nvim/issues/667#issuecomment-1965426553
      programs.nixvim.colorschemes.catppuccin.customHighlights = /* lua */ ''
        function(C)
          local cmpfn = require("catppuccin.groups.integrations.cmp")
          setfenv(cmpfn.get, { C = C })
          local cmp = cmpfn.get()
          for k, v in pairs(cmp) do
            if k:sub(8, 11) == "Kind" then
              cmp[k] = { bg = v.fg, fg = C.base }
            end
          end
          cmp["Folded"] = { bg = C.crust }
          return cmp
        end
      '';
    };
  };
}

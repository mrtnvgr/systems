{ user, ... }: let
  options = { noremap = true; silent = true; };
  mkKeymaps = keymaps: map (x: x // { inherit options; } ) keymaps;
in {
  home-manager.users.${user} = {
    programs.nixvim.globals.mapleader = " ";

    programs.nixvim.keymaps = mkKeymaps [
      # Disable arrow keys
      { key = "<up>";    action = "<nop>"; }
      { key = "<down>";  action = "<nop>"; }
      { key = "<left>";  action = "<nop>"; }
      { key = "<right>"; action = "<nop>"; }

      # Easy search clearing
      { mode = "n"; key = "<Esc>"; action = "<CMD>:nohl<CR>"; }

      # Increment/Decrement numbers
      { mode = "n"; key = "<leader>+"; action = "<C-a>"; }
      { mode = "n"; key = "<leader>-"; action = "<C-x>"; }

      # Turn some cut operations into delete
      { mode = "n"; key = "c"; action = "\"_c"; }
      { mode = "n"; key = "C"; action = "\"_C"; }
      { mode = "n"; key = "x"; action = "\"_x"; }
      { mode = "n"; key = "X"; action = "\"_X"; }

      # Do not copy contents replaced by paste actions
      { mode = "v"; key = "p"; action = "\"_dp"; }
      { mode = "v"; key = "P"; action = "\"_dP"; }

      # Word counters
      {
        mode = "n"; key = "<leader>wc";
        action.__raw = ''function() print("Total words: " .. vim.fn.wordcount().words) end'';
      }
      {
        mode = "v"; key = "<leader>wc";
        action.__raw = ''function() print("Words in visual selection: " .. vim.fn.wordcount().visual_words) end'';
      }
    ];
  };
}

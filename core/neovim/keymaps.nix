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

      # Switch between alternate files (useful for returning from `gd`)
      { mode = "n"; key = "<leader>s"; action = "<CMD>:e #<CR>"; }

      # Do not copy contents replaced by paste actions
      { mode = "v"; key = "p"; action = "\"_dp"; }
      { mode = "v"; key = "P"; action = "\"_dP"; }

      # Turn some cut operations into delete
      { mode = "n"; key = "d"; action = "\"_d"; }
      { mode = "n"; key = "D"; action = "\"_D"; }

      # Word counters
      {
        mode = "n"; key = "<leader>wc";
        action.__raw = ''function() print("Total words: " .. vim.fn.wordcount().words) end'';
      }
      {
        mode = "v"; key = "<leader>wc";
        action.__raw = ''function() print("Words in visual selection: " .. vim.fn.wordcount().visual_words) end'';
      }

      # Increment/Decrement numbers
      { mode = "n"; key = "<leader>+"; action = "<C-a>"; }
      { mode = "n"; key = "<leader>-"; action = "<C-x>"; }
    ];
  };
}

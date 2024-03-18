{ user, ... }:
let
  options = { noremap = true; silent = true; };
in {
  home-manager.users.${user} = {
    programs.nixvim.globals.mapleader = " ";

    programs.nixvim.keymaps = [
      # Yank symbol to /dev/null
      {
        inherit options;
        mode = "n";
        key = "x";
        action = "\"_x";
      }

      # Increment/Decrement numbers
      {
        inherit options;
        mode = "n";
        key = "<leader>+";
        action = "<C-a>";
      }
      {
        inherit options;
        mode = "n";
        key = "<leader>-";
        action = "<C-x>";
      }

      # Disable arrow keys
      {
        inherit options;
        key = "<up>";
        action = "<nop>";
      }
      {
        inherit options;
        key = "<down>";
        action = "<nop>";
      }
      {
        inherit options;
        key = "<left>";
        action = "<nop>";
      }
      {
        inherit options;
        key = "<right>";
        action = "<nop>";
      }

      # Paste and keep content
      {
        inherit options;
        mode = "v";
        key = "p";
        action = "\"_dp";
      }
      {
        inherit options;
        mode = "v";
        key = "p";
        action = "\"_dP";
      }

      # Word counters
      {
        inherit options;
        mode = "n";
        key = "<leader>wc";
        action = "<CMD>lua print(\"Total words: \" .. vim.fn.wordcount().words)<CR>";
      }
      {
        inherit options;
        mode = "v";
        key = "<leader>wc";
        action = "<CMD>lua print(\"Words in visual selection: \" .. vim.fn.wordcount().visual_words)<CR>";
      }
    ];
  };
}

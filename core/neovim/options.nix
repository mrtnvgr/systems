{ user, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    options = {
      # Numbers
      relativenumber = true;
      number = true;

      # Search
      ignorecase = true;
      smartcase = true;

      # Indentation
      autoindent = true;
      smartindent = true;
      expandtab = false; # Use tabs not spaces
      shiftwidth = 4;
      tabstop = 4;
      softtabstop = 0; # Hard tabs

      # Temporary files
      backup = false;
      undofile = true;

      wrap = false;

      mouse = "a";
      guicursor = "";
      clipboard = "unnamedplus";

      termguicolors = true;
      updatetime = 100;
      timeoutlen = 500;

      # Paddings
      signcolumn = "yes";
      cmdheight = 0;

      backspace = "indent,eol,start";

      # Splits
      splitright = true;
      splitbelow = true;

      autoread = true;
      confirm = true;
    };

    extraConfigLua = ''
      -- short mess
      vim.opt.shortmess:append("I") -- hide intro message
      vim.opt.shortmess:append("s") -- hide "search hit BOTTOM ..."
      vim.opt.shortmess:append("c") -- do not pass messages to |ins-completion-menu|

      -- hide ~ blank lines
      vim.opt.fillchars:append("eob: ")
    '';

    globals = {
      netrw_banner = 0; # Hide the Netrw banner
    };
  };
}

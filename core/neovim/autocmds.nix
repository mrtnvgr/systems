{ user, ... }: {
  home-manager.users.${user}.programs.nixvim = {
    autoGroups = {
      USER.clear = true;
    };

    autoCmd = [
      {
        # Disable auto-commenting
        group = "USER";
        event = [ "BufWinEnter" "FileType" ];
        pattern = "*";
        command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o";
      }

      {
        # Text editing mode
        group = "USER";
        event = [ "BufWinEnter" ];
        pattern = [ "*.md" "*.txt" ];
        command = "setlocal wrap";
      }

      {
        # Extra markdown aliases
        group = "USER";
        event = [ "BufEnter" ];
        pattern = [ "TODO" "todo" ];
        command = "setfiletype markdown";
      }

      # Remove trailing space
      {
        group = "USER";
        event = [ "BufWritePre" ];
        callback = {
          __raw = ''
            function(ev)
              save_cursor = vim.fn.getpos(".")
              vim.cmd([[%s/\s\+$//e]])
              vim.fn.setpos(".", save_cursor)
            end
          '';
        };
      }
    ];
  };
}

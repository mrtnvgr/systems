{ user, ... }: {
  home-manager.users.${user} = {
    programs.nixvim = {
      highlightOverride = {
        "@comment.todo".link = "TODO";
        "@comment.note".link = "DiagnosticHint";
        "@comment.warning".link = "DiagnosticWarn";
        "@comment.error".link = "DiagnosticError";
      };
    };
  };
}

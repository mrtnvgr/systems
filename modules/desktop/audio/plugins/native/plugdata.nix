{ pkgs, lib, config, user, ... }: let
  cfg = config.modules.desktop.audio.plugins.native;

  inherit (config.modules.desktop.theme.colorscheme) slug palette;

  theme = pkgs.writeText "plugdata-theme" ''
    <?xml version="1.0" encoding="UTF-8" ?>
    <Theme
      theme="${slug}"
      toolbar_background="ff${palette.background}"
      toolbar_text="ff${palette.text}"
      toolbar_active="ff${palette.blue}"
      toolbar_hover="ff${palette.gray}"
      tabbar_background="ff${palette.void}"
      tab_text="ff${palette.text}"
      selected_tab_background="ff${palette.gray2}"
      selected_tab_text="ff${palette.text}"
      canvas_background="ff${palette.background}"
      canvas_text="ff${palette.text}"
      canvas_dots="ff${palette.gray4}"
      presentation_background="ff${palette.gray2}"
      default_object_background="ff${palette.void}"
      object_outline_colour="ff${palette.gray3}"
      selected_object_outline_colour="ff${palette.blue}"
      gui_internal_outline_colour="ff${palette.gray3}"
      toolbar_outline_colour="ff${palette.background}"
      outline_colour="ff${palette.gray3}"
      data_colour="ff${palette.blue}"
      connection_colour="ff${palette.text}"
      signal_colour="ff${palette.orange}"
      gem_colour="ff${palette.green}"
      dialog_background="ff${palette.void}"
      sidebar_colour="ff${palette.void}"
      sidebar_text="ff${palette.text}"
      sidebar_background_active="ff${palette.gray}"
      levelmeter_active="ff${palette.blue}"
      levelmeter_background="ff${palette.gray2}"
      levelmeter_thumb="ff${palette.text}"
      panel_background="ff${palette.background}"
      panel_foreground="ff${palette.void}"
      panel_text="ff${palette.text}"
      panel_background_active="ff${palette.gray}"
      popup_background="ff${palette.void}"
      popup_background_active="ff${palette.gray}"
      popup_text="ff${palette.text}"
      scrollbar_thumb="ff${palette.gray4}"
      graph_area="ff${palette.red}"
      grid_colour="ff${palette.blue}"
      caret_colour="ff${palette.blue}"
      text_object_background="ff${palette.background}"
      iolet_area_colour="ff${palette.background}"
      iolet_outline_colour="ff${palette.gray3}"
      comment_text_colour="ff${palette.text}"
    />
  '';
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.plugdata ];

    home-manager.users.${user} = {
      # TODO: make modules.desktop.paths.documents option
      # TODO: change config.xdg.userDirs.documents to it too
      home.file.".local/documents/plugdata/${slug}.plugdatatheme".source = theme;
    };
  };
}

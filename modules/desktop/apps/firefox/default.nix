{ inputs, pkgs, lib, config, user, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.desktop.apps.firefox;

  palette = config.colorScheme.palette;
  font = config.modules.desktop.theme.font.name;
in {
  options.modules.desktop.apps.firefox.enable = mkEnableOption "firefox";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.sessionVariables.BROWSER = "firefox";
      imports = [ inputs.schizofox.homeManagerModule ];
      programs.schizofox = {
        enable = true;

        settings = {
          "browser.newtabpage.enabled" = false;
          "browser.tabs.closeWindowWithLastTab" = false;

          # Restore tabs
          "browser.startup.page" = 3;

          # Download files directly to home directory
          "browser.download.folderList" = 0;

          # Unbreak Google Docs copy/paste functionality
          "dom.event.clipboardevents.enabled" = true;
          "dom.event.contextmenu.enabled" = true;
        };

        misc.startPageURL = "about:blank";

        theme = {
          colors = with palette; {
            background-darker = void;
            background = background;
            foreground = text;
            primary = pink;
          };

          font = font;
        };

        search.defaultSearchEngine = "DuckDuckGo";

        # Disable Dark Reader
        extensions.darkreader.enable = false;
        settings."privacy.resistFingerprinting" = false;

        # Enable browser toolbox
        settings."devtools.chrome.enabled" = true;
        settings."devtools.debugger.remote-enabled" = true;

        # Use default firefox ui
        extensions.simplefox.enable = false;

        theme.extraUserChrome = ''
          /* Search bar: hide lock and shield icons, spacers around */
          #identity-box * { display: none !important; }
          #tracking-protection-icon-container { display: none !important; }
          #nav-bar toolbarspring { display: none !important; }

          /* Search bar: hide placeholder text */
          #urlbar-input::placeholder, .searchbar-textbox::placeholder { opacity: 0 !important; }

          /* Tabbar: hide "Close Firefox", "List all tabs" buttons */
          .titlebar-buttonbox-container { display: none; !important; }
          #alltabs-button { display: none !important; }
          #TabsToolbar #new-tab-button { display: none !important; }
          .titlebar-spacer[type="pre-tabs"], .titlebar-spacer[type="post-tabs"] { display: none !important; }

          /* Tabbar: Shrink height */
          #tabbrowser-tabs { max-height: 34px !important; }
          .tabbrowser-tab { align-items: center !important; }

          /* Tabs: remove min width, hide close tab buttons, remove "new tab" button */
          .tabbrowser-tab { flex: unset !important; }
          .tab-close-button { display: none !important; }
          #tabs-newtab-button { display: none !important; }
        '';

        # /* Custom uBlock Origin icon */
        # /* TODO: make a svg, not image */
        # .toolbarbutton[label="uBlock Origin (off)"] {
        #   --webextension-menupanel-image: [[ICON URL]] !important;
        # }
        #
        # .toolbarbutton[data-extensionid="uBlock0@raymondhill.net"] {
        #   --webextension-menupanel-image: [[ICON URL]] !important;
        # }

        # TODO: https://github.com/schizofox/schizofox/issues/84
        extensions = {
          # Overwriting default extensions
          defaultExtensions = {
            "uBlock0@raymondhill.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            "DontFuckWithPaste@raim.ist".install_url = "https://addons.mozilla.org/firefox/downloads/latest/don-t-fuck-with-paste/latest.xpi";
          };
        };
      };
    };
  };
}

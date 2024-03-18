{ inputs, lib, config, user, ... }:
let
  inherit (config.colorScheme) palette;
  inherit (lib) mkIf optionalString optionals;

  rgb_background = inputs.nix-colors.lib.conversions.hexToRGBString ", " palette.background;
  theme = config.modules.desktop.theme;

  isMpdSupported = config.modules.desktop.feats.music.enable;

  style = with palette; /* css */ ''
    * {
      border: none;
      border-radius: 0;
      box-shadow: none;
      min-height: 0;
      margin: 0;
      padding: 0;

      font-family: "${theme.font.name}", sans-serif;
      font-size: 13px;
    }

    @keyframes blink_red {
      to { background-color: #${red}; }
    }

    .warning, .critical, .urgent {
      animation-name: blink_red;
      animation-duration: 1s;
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
    }

    * {
      background-color: transparent;
    }

    window>box, tooltip {
      background-color: rgba(${rgb_background}, ${toString theme.opacity});
    }

    window>box {
      color: #${text};
      border: 2px solid #${blue};
      margin: 8px 10px 0;
    }

    #workspaces button {
      border: 2px solid transparent;
      padding: 2px 3px;
      margin: 4px 2px;

      /* match to hyprland animations */
      transition: all 600ms cubic-bezier(0, 0.75, 0.15, 1.0);
    }

    #workspaces button:nth-child(1) {
      color: #${red};
    }
    #workspaces button.active:nth-child(1) {
      border-color: #${red};
    }

    #workspaces button:nth-child(2) {
      color: #${teal};
    }
    #workspaces button.active:nth-child(2) {
      border-color: #${teal};
    }

    #workspaces button:nth-child(3) {
      color: #${blue};
    }
    #workspaces button.active:nth-child(3) {
      border-color: #${blue};
    }

    #workspaces button:nth-child(4) {
      color: #${violet};
    }
    #workspaces button.active:nth-child(4) {
      border-color: #${violet};
    }

    #workspaces button.empty {
      color: #${text};
    }

    tooltip {
      border: 2px solid #${lavender};
    }

    tooltip label {
      color: #${text};
    }

    #custom-flake {
      font-size: 18px;
      padding-left: 10px;
      padding-right: 6px;
      color: #${blue};
    }

    ${optionalString isMpdSupported "#mpd,"}
    #battery,
    #clock,
    #backlight,
    #wireplumber,
    #tray {
      border-radius: 2px;
      padding: 0px 8px;
      margin: 4px;

      padding-left: 8px;
      padding-right: 8px;

      font-weight: bold;
      transition: all ease-in 200ms;
    }

    ${optionalString isMpdSupported ''
      #mpd.playing {
        color: #${violet};
      }
      #mpd.paused {
        color: #${text};
      }
    ''}

    #wireplumber {
      color: #${red};
    }
    #wireplumber.muted {
      color: #${text};
    }

    #backlight {
      color: #${teal};
    }

    #battery {
      color: #${lavender};
    }

    #clock {
      color: #${violet};
    }
  '';

  settings = [{
    layer = "top";

    modules-left = [ "custom/flake" "hyprland/workspaces" ];
    modules-center = [ ] ++ optionals isMpdSupported [ "mpd" ];
    modules-right = [ "tray" "wireplumber" "backlight" "battery" "clock" ];

    "custom/flake" = {
        "format" = " ";
		"tooltip" = false;
        "on-click" = "pkill rofi || rofi -show drun";
    };

	"hyprland/workspaces" = {
		"persistent-workspaces" = { "*" = 4; };
	};

	"mpd" = {
		"format" = "{stateIcon} {artist} - {title} ({songPosition}/{queueLength})";
		"state-icons" = { "playing" = ""; "paused" = ""; };
		"on-click" = "mpc toggle -q";
		"format-disconnected" = "";
		"format-stopped" = "";
        "max-length" = 140;
		"tooltip" = false;
		"interval" = 2;
	};

	"tray" = {
		"icon-size" = 12;
		"spacing" = 5;
	};

	"wireplumber" = {
		"format" = "{icon} {volume}%";
		"format-muted" = "󰝟 {volume}%";
		"on-click" = "amixer -q sset Master toggle";
		"format-icons" = [ "" "" "" ];
	};

	"backlight" = {
		"format" = "{icon} {percent}%";
		"format-icons" = [ "" "" ];
	};

	"battery" = {
		"interval" = 10;
		"states" = {
			"warning" = 30;
			"critical" = 15;
		};
		"format" = "󰂄 {capacity}%";
		"format-discharging" = "{icon} {capacity}%";
		"format-icons" = [ "󰂎" "󰁻" "󰁾" "󰂀" "󰁹" ];
	};

	"clock" = {
		"interval" = 1;
		"format" = " {:%H:%M}";
		"format-alt" = " {:%e %B %Y}";
		"tooltip" = false;
	};
  }];
in {
  config = mkIf (theme.rice == "hyprpop") {
    home-manager.users.${user} = {
      programs.waybar = {
        enable = true;

        inherit style settings;
      };
    };
  };
}

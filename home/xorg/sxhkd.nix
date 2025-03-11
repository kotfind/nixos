{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) getExe getExe' escapeShellArgs;
  inherit (pkgs) writeShellScriptBin;
  inherit (config.cfgLib) enableFor matchFor hosts users;

  bspc = getExe' pkgs.bspwm "bspc";
  alacritty = getExe pkgs.alacritty;
  rofi = getExe pkgs.rofi;
  pactl = getExe' pkgs.pulseaudio "pactl";
  light = getExe pkgs.light;
  playerctl = getExe pkgs.playerctl;
  systemctl = getExe' pkgs.systemd "systemctl";
  loginctl = getExe' pkgs.systemd "loginctl";
  rofi-pass = getExe pkgs.rofi-pass;
  pkill = getExe' pkgs.toybox "pkill";
  xprop = getExe pkgs.xorg.xprop;
  sed = getExe pkgs.gnused;
  firefox = getExe pkgs.firefox;
  true_ = getExe' pkgs.toybox "true";
  echo = getExe' pkgs.toybox "echo";
  grep = getExe pkgs.gnugrep;

  scrotWithArgs = args:
    escapeShellArgs
    ([(getExe pkgs.scrot)]
      ++ args
      ++ ["/tmp/screenshots/%s.png"]);

  keybindings =
    {
      # -------------------- Launch --------------------

      # launch terminal
      "super + Return" = alacritty;

      # launch app
      "super + @space" = "${rofi} -show drun";
    }
    // {
      # -------------------- Quit / reload --------------------

      # quit bspwm
      "super + alt + q" = "${bspc} quit";

      # restart bspwm (and sxhkd)
      "super + alt + r" = getExe (
        writeShellScriptBin "restart-bspwm" ''
          ${bspc} wm -r
          ${pkill} -l USR1 -x sxhkd
        ''
      );

      # close/ kill a window
      "super + w" = "${bspc} node -c";
      "super + shift + w" = "${bspc} node -k";
    }
    // {
      # -------------------- Layout --------------------

      # switch layout
      "super + m" = "${bspc} desktop -l next";

      # change window state
      "super + s" = "${bspc} node -t floating";
      "super + t" = "${bspc} node -t tiled";
      "super + T" = "${bspc} node -t pseudo_tiled";

      # sticky
      "super + shift + s" = "${bspc} node -g sticky";

      # balance nodes
      "super + b" = "${bspc} node @/ -E";
      "super + B" = "${bspc} node @/ -B";

      # rotate parent
      "super + r" = "${bspc} node @parent -R 90";
    }
    // {
      # -------------------- Move / Focus / Resize Windows --------------------

      # focus window in direction
      "super + {h,j,k,l}" = "${bspc} node -f {west,south,north,east}";

      # move window in direction
      "super + shift + {h,j,k,l}" = "${bspc} node -s {west,south,north,east}";

      # focus parent/ first child / second child
      "super + {p,i,I}" = "${bspc} node -f @{parent,first,second}";

      # cycle through windows
      "super + {_,shift + } c" = "${bspc} node -f {next,prev}.local.!hidden.window";

      # move floating window
      "super + {Left,Down,Up,Right}" = "${bspc} node -v {-20 0,0 20,0 -20,20 0}";

      # smart resize node
      "super + alt + {h, j, k, l}" = let
        script = writeShellScriptBin "bspc-resize-node" ''
          dir="$1"
          step=20
          case $dir in
              'left')   { bspc node -z left   -$step 0 || bspc node -z right  -$step 0; } ;;
              'top')    { bspc node -z top    0 +$step || bspc node -z bottom 0 +$step; } ;;
              'bottom') { bspc node -z bottom 0 -$step || bspc node -z top    0 -$step; } ;;
              'right')  { bspc node -z right  +$step 0 || bspc node -z left   +$step 0; } ;;
          esac
        '';
      in "${getExe script} {'left','top','bottom','right'}";
    }
    // {
      # -------------------- Preselection --------------------

      # preselect direction
      "super + ctrl + {h,j,k,l}" = "${bspc} node -p {west,south,north,east}";

      # preselect ratio
      "super + ctrl + {1-9}" = "${bspc} node -o 0.{1-9}";

      # cancel preselection
      "super + ctrl + space" = "${bspc} node -p cancel";

      # send (move) node to preselected area
      "super + ctrl + Return" = "${bspc} node -n 'last.!automatic.local'";
    }
    // {
      # -------------------- Focus / Move Desktops --------------------

      # focus next desktop (on the same monitor)
      "super + bracket{left,right}" = "${bspc} desktop -f {prev,next}.local";

      # focus desktop by number (on same monitor)
      "super + {1-9}" = "${bspc} desktop -f '{1-9}.local'";

      # send window to a desktop by number (on same monitor)
      "super + shift + {1-9}" = "${bspc} node -d '{1-9}.local'";

      # focus previous / next monitor
      "super + {comma,period}" = "${bspc} monitor -f {prev,next}";

      # send window to another monitor
      "super + shift + {comma,period}" = "${bspc} node -m {prev,next}";
    }
    // {
      # -------------------- Special Keys --------------------

      # screenshot whole screen / selected area / current window
      "Print" = scrotWithArgs [];
      "shift + Print" = scrotWithArgs ["-f" "-s"];
      "ctrl + Print" = scrotWithArgs ["-f" "-u"];

      # volume mute / up / down
      "XF86AudioMute" = "${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
      "{XF86AudioRaiseVolume,XF86AudioLowerVolume}" = "${pactl} set-sink-volume @DEFAULT_SINK@ {+,-}5%";

      # brightness up / down
      "XF86MonBrightness{Up,Down}" =
        enableFor
        hosts.laptop
        "${light} {-A,-U} 5";

      # media keys
      "XF86{Play,Stop,Pause,Next,Prev}" = "${playerctl} {play-pause,play-pause,play-pause,next,previous}";

      # lock / suspend / hibernate
      "super + z" = "${loginctl} lock-session";
      "super + shift + z" = "${systemctl} suspend -i";
      "super + shift + ctrl + z" = "${systemctl} hibernate -i";
    }
    // {
      # -------------------- Miscellaneous --------------------

      # run/ focus firefox firefox
      "super + {_, shift} + f" = let
        script = writeShellScriptBin "focus-or-open-firefox" ''
          set -euo pipefail
          set -x

          case "$1" in
            'normal')
              wm_name_suffix='Mozilla Firefox'
              firefox_flag='--new-window'
              ;;

            'private')
              wm_name_suffix='Mozilla Firefox Private Browsing'
              firefox_flag='--private-window'
              ;;

            *)
              echo "unknown window type '$1'" 1>&2
              exit 1
              ;;
          esac

          ids=($(${bspc} query -N -n '.local.window' | ${true_}))
          for id in "''${ids[@]}"; do
            name="$(
              ${xprop} -id "$id" -notype WM_NAME | \
              ${sed} 's/^WM_NAME = "\(.*\)"$/\1/' | \
              ${sed} 's/\"/"/'
            )"

            if ${echo} "$name" | ${grep} -q "$wm_name_suffix$"; then
              ${bspc} node -f "$id"
              exit 0
            fi
          done

          ${firefox} "$firefox_flag"
        '';
      in "${getExe script} {normal,private}";

      # password
      "super + e" = rofi-pass;
    };
in {
  services.sxhkd = {
    enable = matchFor users.kotfind;
    inherit keybindings;
  };
}

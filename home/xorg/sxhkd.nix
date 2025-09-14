{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) getExe getExe' escapeShellArgs;
  inherit (pkgs) writeShellScriptBin;
  inherit (config.cfgLib) matchFor hosts users;

  focusOrOpenFirefox = getExe (import ./scripts/focus-or-open-firefox.nix {inherit pkgs;});
  bspcResizeNode = getExe (import ./scripts/bspc-resize-node.nix {inherit pkgs;});

  showVolumeNotify = getExe (import ./scripts/show-volume-notify.nix {inherit pkgs;});
  showMusicNotify = getExe (import ./scripts/show-music-notify.nix {inherit pkgs;});
  showBrightnessNotify =
    if matchFor hosts.laptop
    then (getExe (import ./scripts/show-brightness-notify.nix {inherit pkgs config;}))
    else "";

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
  scrot = getExe pkgs.scrot;

  scrotWithArgs = args:
    escapeShellArgs (
      [scrot]
      ++ args
      ++ ["/tmp/screenshots/%s.png"]
    );

  muteVolume = writeShellScriptBin "mute-volume" ''
    ${pactl} set-sink-mute @DEFAULT_SINK@ toggle
    ${showVolumeNotify}
  '';

  changeVolume = writeShellScriptBin "change-volume" ''
    ${pactl} set-sink-volume @DEFAULT_SINK@ ''${1}5%
    ${showVolumeNotify}
  '';

  changeBrightness = writeShellScriptBin "change-brightness" ''
    ${light} $1 5
    ${showBrightnessNotify}
  '';

  doMediaAction = writeShellScriptBin "do-media-action" ''
    ${playerctl} $1
    ${showMusicNotify}
  '';

  restartBspwm = writeShellScriptBin "restart-bspwm" ''
    ${bspc} wm -r
    ${pkill} -l USR1 -x sxhkd
  '';
in {
  services.sxhkd = {
    enable = matchFor users.kotfind;
    keybindings = {
      # -------------------- Launch --------------------

      # launch terminal
      "super + Return" = alacritty;

      # launch app
      "super + @space" = "${rofi} -show drun";

      # -------------------- Quit / reload --------------------

      # quit bspwm
      "super + alt + q" = "${bspc} quit";

      # restart bspwm (and sxhkd)
      "super + alt + r" = "${getExe restartBspwm}";

      # close/ kill a window
      "super + w" = "${bspc} node -c";
      "super + shift + w" = "${bspc} node -k";

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
      "super + alt + {h, j, k, l}" = "${bspcResizeNode} {'left','top','bottom','right'}";

      # -------------------- Preselection --------------------

      # preselect direction
      "super + ctrl + {h,j,k,l}" = "${bspc} node -p {west,south,north,east}";

      # preselect ratio
      "super + ctrl + {1-9}" = "${bspc} node -o 0.{1-9}";

      # cancel preselection
      "super + ctrl + space" = "${bspc} node -p cancel";

      # send (move) node to preselected area
      "super + ctrl + Return" = "${bspc} node -n 'last.!automatic.local'";

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

      # -------------------- Special Keys --------------------

      # screenshot whole screen / selected area / current window
      "Print" = scrotWithArgs [];
      "shift + Print" = scrotWithArgs ["-f" "-s"];
      "ctrl + Print" = scrotWithArgs ["-f" "-u"];

      # volume mute / up / down
      "XF86AudioMute" = "${getExe muteVolume}";
      "{XF86AudioRaiseVolume,XF86AudioLowerVolume}" = "${getExe changeVolume} {+,-}";

      # brightness up / down
      "XF86MonBrightness{Up,Down}" =
        if matchFor hosts.laptop
        then "${getExe changeBrightness} {-A,-U}"
        else "";

      # media keys
      "XF86{Play,Stop,Pause,Next,Prev}" = "${getExe doMediaAction} {play-pause,stop,pause,next,previous}";

      # lock / suspend / hibernate
      "super + z" = "${loginctl} lock-session";
      "super + shift + z" = "${systemctl} suspend -i";
      "super + shift + ctrl + z" = "${systemctl} hibernate -i";

      # -------------------- Miscellaneous --------------------

      # run/ focus firefox firefox
      "super + {_, shift} + f" = "${focusOrOpenFirefox} {normal,private}";

      # password
      "super + e" = rofi-pass;
    };
  };
}

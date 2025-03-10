{
  pkgs,
  lib,
  config,
  ...
}:
with (with pkgs; {
  bspc = lib.getExe' bspwm "bspc";
  alacritty = lib.getExe alacritty;
  rofi = lib.getExe rofi;
  scrot = lib.getExe scrot;
  pactl = lib.getExe' pulseaudio "pactl";
  light = lib.getExe light;
  playerctl = lib.getExe playerctl;
  systemctl = lib.getExe' systemd "systemctl";
  loginctl = lib.getExe' systemd "loginctl";
  rofi-pass = lib.getExe rofi-pass;
  pkill = lib.getExe' toybox "pkill";
}); let
  keybindings = {
    # Run terminal
    "super + Return" = alacritty;

    # Launch program
    "super + @space" =
      /*
      bash
      */
      ''
        ${rofi} -show drun
      '';

    # quit bspwm
    "super + alt + q" =
      /*
      bash
      */
      ''
        ${bspc} quit
      '';

    # restart bspwm (and sxhkd)
    "super + alt + r" =
      /*
      bash
      */
      ''
        ${bspc} wm -r
        ${pkill} -USR1 -x sxhkd
      '';

    # close/ kill a window
    "super + {_,shift + }w" =
      /*
      bash
      */
      ''
        ${bspc} node -{c,k}
      '';

    # switch layout
    "super + m" =
      /*
      bash
      */
      ''
        ${bspc} desktop -l next
      '';

    # change window state
    "super + {t,T,s}" =
      /*
      bash
      */
      ''
        ${bspc} node -t {tiled,pseudo_tiled,floating}
      '';

    # sticky
    "super + shift + s" =
      /*
      bash
      */
      ''
        ${bspc} node -g sticky
      '';

    # balance
    "super + b" =
      /*
      bash
      */
      ''
        ${bspc} node @/ -E
      '';

    "super + B" =
      /*
      bash
      */
      ''
        ${bspc} node @/ -B
      '';

    # rotate parent
    "super + r" =
      /*
      bash
      */
      ''
        ${bspc} node @parent -R 90
      '';

    # focus/ swap
    "super + {_,shift + }{h,j,k,l}" =
      /*
      bash
      */
      ''
        ${bspc} node -{f,s} {west,south,north,east}
      '';

    "super + {p,i,I}" =
      /*
      bash
      */
      ''
        ${bspc} node -f @{parent,first,second}
      '';

    "super + {_,shift + } c" =
      /*
      bash
      */
      ''
        ${bspc} node -f {next,prev}.local.!hidden.window
      '';

    "super + bracket{left,right}" =
      /*
      bash
      */
      ''
        ${bspc} desktop -f {prev,next}.local
      '';

    "super + {_,shift + }{1-9}" =
      /*
      bash
      */
      ''
        ${bspc} {desktop -f,node -d} '{1-9}.local'
      '';

    # preselect
    "super + ctrl + {h,j,k,l}" =
      /*
      bash
      */
      ''
        ${bspc} node -p {west,south,north,east}
      '';

    "super + ctrl + {1-9}" =
      /*
      bash
      */
      ''
        ${bspc} node -o 0.{1-9}
      '';

    "super + ctrl + space" =
      /*
      bash
      */
      ''
        ${bspc} node -p cancel
      '';

    "super + ctrl + Return" =
      /*
      bash
      */
      ''
        ${bspc} node -n 'last.!automatic.local'
      '';

    # move/ resize

    # move floating
    "super + {Left,Down,Up,Right}" =
      /*
      bash
      */
      ''
        ${bspc} node -v {-20 0,0 20,0 -20,20 0}
      '';

    "super + alt + {h, j, k, l}" = let
      script =
        pkgs.writeShellScript "bspc-resize-node"
        /*
        bash
        */
        ''
          dir="$1"
          step=20
          case $dir in
              'left')   { bspc node -z left   -$step 0 || bspc node -z right  -$step 0; } ;;
              'top')    { bspc node -z top    0 +$step || bspc node -z bottom 0 +$step; } ;;
              'bottom') { bspc node -z bottom 0 -$step || bspc node -z top    0 -$step; } ;;
              'right')  { bspc node -z right  +$step 0 || bspc node -z left   +$step 0; } ;;
          esac
        '';
    in "${script} {'left','top','bottom','right'}";

    # screenshot
    "{ ,shift,ctrl} + Print" =
      /*
      bash
      */
      ''
        ${scrot} { ,-f -s, -f -u} '/tmp/screenshots/%s.png'
      '';

    # volume
    "XF86AudioMute" =
      /*
      bash
      */
      ''
        ${pactl} set-sink-mute @DEFAULT_SINK@ toggle
      '';

    "{XF86AudioRaiseVolume,XF86AudioLowerVolume}" =
      /*
      bash
      */
      ''
        ${pactl} set-sink-volume @DEFAULT_SINK@ {+,-}5%
      '';

    # brightness
    "XF86MonBrightness{Up,Down}" =
      (with config.cfgLib; enableFor hosts.laptop)
      /*
      bash
      */
      ''
        ${light} {-A,-U} 5
      '';

    # media
    # TODO: FIXME: Unkown keysym name: ...
    "XF86{Play,Stop,Pause,Next,Prev}" =
      /*
      bash
      */
      ''
        ${playerctl} {play-pause,play-pause,play-pause,next,previous}
      '';

    # lock/ suspend/ hibernate
    "super + z" =
      /*
      bash
      */
      ''
        ${loginctl} lock-session
      '';

    "super + shift { , + ctrl} + z" =
      /*
      bash
      */
      ''
        ${systemctl} {suspend,hibernate} -i
      '';

    # firefox
    # TODO: switch to ff window is already opened
    "super { , + shift} + f" =
      /*
      bash
      */
      ''
        firefox {--new-window,--private-window}
      '';

    # password
    "super + e" = rofi-pass;

    # focus / send window to monitor
    "super + {_,shift} + {comma,period}" =
      /*
      bash
      */
      ''
        ${bspc} {monitor -f,node -m} {prev,next}
      '';
  };
in {
  services.sxhkd = (with config.cfgLib; enableFor users.kotfind) {
    enable = true;
    inherit keybindings;
  };
}

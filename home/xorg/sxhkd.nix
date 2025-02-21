{ pkgs, lib, config, ... }:
let
    bspc = "${pkgs.bspwm}/bin/bspc";
    alacritty = "${lib.getExe pkgs.alacritty}";
    rofi = "${lib.getExe pkgs.rofi}";
    scrot = "${lib.getExe pkgs.scrot}";
    pactl = "${pkgs.pulseaudio}/bin/pactl";
    light = "${lib.getExe pkgs.light}";
    playerctl = "${lib.getExe pkgs.playerctl}";
    systemctl = "${pkgs.systemd}/bin/systemctl";
    loginctl = "${pkgs.systemd}/bin/loginctl";
    rofi-pass = "${lib.getExe pkgs.rofi-pass}";

    keybindings = {
        # Run terminal
        "super + Return" = alacritty;

        # Launch program
        "super + @space" = /* bash */ ''
            ${rofi} -show drun
        '';

        # quit/ restart bspwm
        "super + alt + {q,r}" = /* bash */ ''
            ${bspc} {quit,wm -r}
        '';

        # close/ kill a window
        "super + {_,shift + }w" = /* bash */ ''
            ${bspc} node -{c,k}
        '';

        # switch layout
        "super + m" = /* bash */ ''
            ${bspc} desktop -l next
        '';

        # change window state
        "super + {t,s}" = /* bash */ ''
            ${bspc} node -t {tiled,floating}
        '';

        # sticky
        "super + shift + s" = /* bash */ ''
            ${bspc} node -g sticky
        '';

        # focus/ swap
        "super + {_,shift + }{h,j,k,l}" = /* bash */ ''
            ${bspc} node -{f,s} {west,south,north,east}
        '';

        "super + {p,b,comma,period}" = /* bash */ ''
            ${bspc} node -f @{parent,brother,first,second}
        '';

        "super + {_,shift + } c" = /* bash */ ''
            ${bspc} node -f {next,prev}.local.!hidden.window
        '';

        "super + bracket{left,right}" = /* bash */ ''
            ${bspc} desktop -f {prev,next}.local
        '';

        "super + {o,i}" = 
            let
                script = pkgs.writeShellScript "bspc-switch-older-newer-node" /* bash */ ''
                    ${bspc} wm -h off
                    ${bspc} node "$1" -f
                    ${bspc} wm -h on
                '';
            in
            "${script} {older,newer}";

        "super + {_,shift + }{1-9}" = /* bash */ ''
            ${bspc} {desktop -f,node -d} '^{1-9}'
        '';

        # preselect
        "super + ctrl + {h,j,k,l}" = /* bash */ ''
            ${bspc} node -p {west,south,north,east}
        '';

        "super + ctrl + {1-9}" = /* bash */ ''
            ${bspc} node -o 0.{1-9}
        '';


        "super + ctrl + space" = /* bash */ ''
            ${bspc} node -p cancel
        '';

        # move/ resize

        # move floating
        "super + {Left,Down,Up,Right}" = /* bash */ ''
            ${bspc} node -v {-20 0,0 20,0 -20,20 0}
        '';

        
        "super + alt + {h, j, k, l}" =
            let
                script = pkgs.writeShellScript "bspc-resize-node" /* bash */ ''
                    dir="$1"
                    step=20
                    case $dir in
                        'left')   { bspc node -z left   -$step 0 || bspc node -z right  -$step 0; } ;;
                        'top')    { bspc node -z top    0 +$step || bspc node -z bottom 0 +$step; } ;;
                        'bottom') { bspc node -z bottom 0 -$step || bspc node -z top    0 -$step; } ;;
                        'right')  { bspc node -z right  +$step 0 || bspc node -z left   +$step 0; } ;;
                    esac
                '';
            in
                "${script} {'left','top','bottom','right'}";

        # screenshot
        "{ ,shift,ctrl} + Print" = /* bash */ ''
            ${scrot} { ,-f -s, -f -u} '/tmp/screenshots/%s.png'
        '';

        # volume
        "XF86AudioMute" = /* bash */ ''
            ${pactl} set-sink-mute @DEFAULT_SINK@ toggle
        '';

        "{XF86AudioRaiseVolume,XF86AudioLowerVolume}" = /* bash */ ''
            ${pactl} set-sink-volume @DEFAULT_SINK@ {+,-}5%
        '';

        # brightness
        "XF86MonBrightness{Up,Down}" = (with config.cfgLib; enableFor hosts.laptop) /* bash */ ''
            ${light} {-A,-U} 5
        '';

        # media
        # TODO: FIXME: Unkown keysym name: ...
        "XF86{Play,Stop,Pause,Next,Prev}" = /* bash */ ''
            ${playerctl} {play-pause,play-pause,play-pause,next,previous}
        '';

        # lock/ suspend/ hibernate
        "super + z" = /* bash */ ''
            ${loginctl} lock-session
        '';

        "super + shift { , + ctrl} + z" = /* bash */ ''
            ${systemctl} {suspend,hibernate} -i
        '';

        # firefox
        # TODO: switch to ff window is already opened
        "super { , + shift} + f" = /* bash */ ''
            firefox {--new-window,--private-window}
        '';

        # password
        "super + e" = rofi-pass;
    };
in
{
    services.sxhkd = (with config.cfgLib; enableFor users.kotfind) {
        enable = true;
        inherit keybindings;
    };
}

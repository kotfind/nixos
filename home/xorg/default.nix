{ pkgs, ... }:
let
    autostartService =
        {
            cmd,
            executor ? "",
            packages ? [],
            isOneshot ? false,
            remainAfterExit ? isOneshot,
        } : {
            Install = {
                WantedBy = [ "graphical-session.target" ];
            };

            Service = {
                ExecStart = "${executor} ${cmd}";

                Environment = let
                        path = pkgs.lib.concatMapStringsSep
                            ":"
                            (pkg: "${pkg}/bin")
                            packages;
                    in [ "PATH=${path}" ];

                RemainAfterExit = remainAfterExit;

                Type = if isOneshot then "oneshot" else "simple";
            };

            Unit = {
                After = [ "graphical-session-pre.target" ];
                PartOf = [ "graphical-session.target" ];
            };
        };
in
{
    xsession = {
        enable = true;
        windowManager.bspwm = {
            enable = true;
            extraConfig = builtins.readFile ./.config/bspwm/bspwmrc;
        };
    };

    services.sxhkd = {
        enable = true;
        extraConfig = builtins.readFile ./.config/sxhkd/sxhkdrc;
    };

    systemd.user.services = {
        lemonbar = autostartService {
            cmd = ./.config/lemonbar/lemonbar.sh;
            executor = "${pkgs.bash}/bin/bash -c";
            packages = with pkgs; [
                bash
                lemonbar-xft
                xtitle
                trayer
                fira-code
                fira-code-nerdfont
                gawk
                toybox
                pulseaudio
                bspwm
                xorg.xrandr
            ];
        };

        polkit = autostartService {
            cmd = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
            packages = [ pkgs.lxqt.lxqt-policykit ];
        };
    };

    services.batsignal = {
        enable = true;
        extraArgs = [
            "-f" "99"
            "-w" "30"
            "-c" "10"
            "-d" "5"
            "-p"
        ];
    };

    services.screen-locker = {
        enable = true;
        lockCmd = "${pkgs.xlockmore}/bin/xlock -echokeys";
    };

    home.packages = with pkgs; [
        # for sxhkd
        scrot
        rofi
        pulseaudio
        light # TODO: for laptop only
        playerctl
    ];

    home.sessionVariables = {
        # for some java gui apps to work:
        _JAVA_AWT_WM_NONREPARENTING = 1;
    };
}

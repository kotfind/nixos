{ pkgs, config, lib, ... }:
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
                        path = lib.concatMapStringsSep
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
    xsession = (with config.cfgLib; enableFor users.kotfind) {
        enable = true;
        windowManager.bspwm = {
            enable = true;
            extraConfig = builtins.readFile ./.config/bspwm/bspwmrc;
        };
    };

    services.sxhkd = (with config.cfgLib; enableFor users.kotfind) {
        enable = true;
        extraConfig = builtins.readFile ./.config/sxhkd/sxhkdrc;
    };

    systemd.user.services = (with config.cfgLib; enableFor users.kotfind) {
        lemonbar = autostartService {
            cmd = ./.config/lemonbar/lemonbar.sh;
            executor = "${pkgs.bash}/bin/bash -c";
            packages = with pkgs; [
                bash
                lemonbar-xft
                xtitle
                trayer
                fira-code
                nerd-fonts.fira-code
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

    services.batsignal = with config.cfgLib; 
        enableFor hosts.laptop.users.kotfind {
            enable = true;
            extraArgs = [
                "-f" "99"
                "-w" "30"
                "-c" "10"
                "-d" "5"
                "-p"
            ];
        };

    services.gpg-agent = (with config.cfgLib; enableFor users.kotfind) {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        pinentryPackage = pkgs.pinentry-rofi;
    };

    services.screen-locker = (with config.cfgLib; enableFor users.kotfind) {
        enable = true;
        lockCmd = "${pkgs.xlockmore}/bin/xlock -echokeys";
    };

    # for sxhkd
    home.packages = lib.mkMerge [
        (with config.cfgLib; enableFor users.kotfind
            (with pkgs; [
                scrot
                rofi
                pulseaudio
                playerctl
            ])
        )
        (with config.cfgLib; enableFor hosts.laptop.users.kotfind
            (with pkgs; [
                light
            ])
        )
    ];

    home.sessionVariables = (with config.cfgLib; enableFor users.kotfind) {
        # for some java gui apps to work:
        _JAVA_AWT_WM_NONREPARENTING = 1;
    };

    systemd.user.tmpfiles.rules = (with config.cfgLib; enableFor users.kotfind)
        (let
            user = config.cfgLib.user.name;
            home = config.home.homeDirectory;
        in [
            # Type  Path               Mode  User     Group   Age  Argument
            "d      /tmp/downloads     0755  ${user}  users   -    -"
            "d      /tmp/screenshots   0755  ${user}  users   -    -"
            "L+     ${home}/Downloads  -     -        -       -    /tmp/downloads"
        ]);
}

{ pkgs, cfg, ... }:
{
    home.file.".config/lemonbar/lemonbar.sh" = {
        source = ./.config/lemonbar/lemonbar.sh;
        executable = true;
    };

    systemd.user.services = {
        lemobar = {
            Install = {
                WantedBy = [ "graphical-session.target" ];
            };

            Service = {
                # FIXME: hardcoded home directory
                ExecStart = "${pkgs.bash}/bin/bash /home/${cfg.username}/.config/lemonbar/lemonbar.sh";
                Type = "simple";
                # RemainAfterExit = true;
                # Type = "oneshot";
                Environment = let
                        path = pkgs.lib.concatMapStringsSep
                            ":"
                            (pkg: "${pkg}/bin")
                            (with pkgs; [
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
                            ]);
                    in [ "PATH=${path}" ];
            };

            Unit = {
                After = [ "graphical-session-pre.target" ];
                PartOf = [ "graphical-session.target" ];
            };
        };
    };

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

    home.packages = with pkgs; [
        # lemonbar
        lemonbar-xft
        xtitle
        trayer
        fira-code
        fira-code-nerdfont

        # for sxhkd
        scrot
        rofi
        pulseaudio # for pactl
        light # TODO: for laptop only
        playerctl

        # for init & autostart
        xorg.xinit
        lxqt.lxqt-policykit
        batsignal
        xss-lock
        xlockmore
    ];

    # TODO: startx on login
}

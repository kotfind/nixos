{ pkgs, ... }:
{
    # home.file.".xinitrc".source = ./.xinitrc;
    # home.file."autostart.sh".source = ./autostart.sh;
    home.file.".config/lemonbar/lemonbar.sh".source = ./.config/lemonbar/lemonbar.sh;

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

{ pkgs, ... }:
{
    home.file.".xinitrc".source = ./.xinitrc;
    home.file."autostart.sh".source = ./autostart.sh;
    home.file.".config/bspwm/bspwmrc".source = ./.config/bspwm/bspwmrc;
    home.file.".config/lemonbar/lemonbar.sh".source = ./.config/lemonbar/lemonbar.sh;
    home.file.".config/sxhkd/sxhkdrc".source = ./.config/sxhkd/sxhkdrc;

    home.packages = with pkgs; [
        # bspwm
        bspwm

        # lemonbar
        lemonbar-xft
        xtitle
        trayer
        fira-code
        fira-code-nerdfont

        # for sxhkd
        sxhkd
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

{ pkgs, ... }:
{
    home.packages = with pkgs; [
        # init
        lxqt.lxqt-policykit
        xorg.xinit

	# bspwm
	bspwm

        # lemonbar
        lemonbar-xft
        xtitle
        trayer

        # for sxhkd
	sxhkd
        scrot
        rofi
    ];

    home.file.".xinitrc".source = ./.xinitrc;
    home.file."autostart.sh".source = ./autostart.sh;
    home.file.".config/bspwm/bspwmrc".source = ./.config/bspwm/bspwmrc;
    home.file.".config/lemonbar/lemonbar.sh".source = ./.config/lemonbar/lemonbar.sh;
    home.file.".config/sxhkd/sxhkdrc".source = ./.config/sxhkd/sxhkdrc;

    # TODO: autostart
}

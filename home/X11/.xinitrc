# for some nixos stuff to work
source ~/.xsession

# for some java gui apps to work:
export _JAVA_AWT_WM_NONREPARENTING=1

# dwm
exec bspwm 2> ~/.bspwm.log

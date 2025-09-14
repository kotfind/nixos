# NOTE: not a module
{pkgs}:
pkgs.writeShellApplication {
  name = "bspc-resize-node";
  runtimeInputs = with pkgs; [
    bspwm
  ];
  text = ''
    dir="$1"
    step=20
    case $dir in
        'left')   { bspc node -z left   -$step 0 || bspc node -z right  -$step 0; } ;;
        'top')    { bspc node -z top    0 +$step || bspc node -z bottom 0 +$step; } ;;
        'bottom') { bspc node -z bottom 0 -$step || bspc node -z top    0 -$step; } ;;
        'right')  { bspc node -z right  +$step 0 || bspc node -z left   +$step 0; } ;;
    esac
  '';
}

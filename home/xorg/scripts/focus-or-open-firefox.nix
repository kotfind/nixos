# NOTE: not a module
{pkgs}:
pkgs.writeShellApplication {
  name = "focus-or-open-firefox";

  runtimeInputs = with pkgs; [
    bspwm
    xorg.xprop
    gnused
    firefox
    toybox
    gnugrep
  ];

  text = ''
    set -euo pipefail
    set -x

    case "$1" in
      'normal')
        wm_name_suffix='Mozilla Firefox'
        firefox_flag='--new-window'
        ;;

      'private')
        wm_name_suffix='Mozilla Firefox Private Browsing'
        firefox_flag='--private-window'
        ;;

      *)
        echo "unknown window type '$1'" 1>&2
        exit 1
        ;;
    esac

    # shellcheck disable=SC2207
    ids=($(bspc query -N -n '.local.window' | true))
    for id in "''${ids[@]}"; do
      name="$(
        xprop -id "$id" -notype WM_NAME | \
        sed 's/^WM_NAME = "\(.*\)"$/\1/' | \
        sed 's/\"/"/'
      )"

      if echo "$name" | grep -q "$wm_name_suffix$"; then
        bspc node -f "$id"
        exit 0
      fi
    done

    firefox "$firefox_flag"
  '';
}

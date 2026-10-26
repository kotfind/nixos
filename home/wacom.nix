{pkgs, ...}: let
  inherit (pkgs) writeShellApplication;

  baseDevice = "Wacom Bamboo 16FG 4x5";
  stylusDevice = "${baseDevice} Pen stylus";
  eraserDevice = "${baseDevice} Pen eraser";
  fingerDevice = "${baseDevice} Finger touch";
  padDevice = "${baseDevice} Pad pad";

  wacomSetup = writeShellApplication {
    name = "wacom-setup";

    runtimeInputs = with pkgs; [
      gnused
      xf86-input-wacom
      xrandr
    ];

    text = ''
      screen="$(xrandr --current | sed -n 's/.* current \([0-9]\+\) x \([0-9]\+\).*/\1x\2+0+0/p')"

      xsetwacom --set '${stylusDevice}' MapToOutput "$screen"
      xsetwacom --set '${eraserDevice}' MapToOutput "$screen"
      xsetwacom --set '${fingerDevice}' TOUCH off
      xsetwacom --set '${padDevice}' Button 1 'key z'
      xsetwacom --set '${padDevice}' Button 3 'key ctrl'
      xsetwacom --set '${stylusDevice}' Button 2 'key shift'
      xsetwacom --set '${stylusDevice}' Button 3 'key button +2'
    '';
  };

  wacomToggleTouch = writeShellApplication {
    name = "wacom-toggle-touch";

    runtimeInputs = with pkgs; [
      xf86-input-wacom
    ];

    text = ''
      state="$(xsetwacom --get '${fingerDevice}' TOUCH 2>/dev/null)" || exit 1

      if [ "$state" == 'on' ]; then
        xsetwacom --set "${fingerDevice}" TOUCH off
      else
        xsetwacom --set "${fingerDevice}" TOUCH on
      fi
    '';
  };
in {
  home.packages = [
    wacomSetup
    wacomToggleTouch
  ];
}

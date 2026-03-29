{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkMerge mkBefore mkAfter getExe';

  bleshShareBin = getExe' pkgs.blesh "blesh-share";
in {
  programs.bash.initExtra = mkMerge [
    (mkBefore ''
      source -- "$(${bleshShareBin})"/ble.sh --attach=none
    '')

    (mkAfter ''
      [[ ! ''${BLE_VERSION-} ]] || ble-attach
    '')
  ];

  home.packages = with pkgs; [
    blesh
  ];
}

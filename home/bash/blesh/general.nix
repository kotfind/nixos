{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkMerge mkBefore mkAfter getExe getExe';

  bleshShareBin = getExe' pkgs.blesh "blesh-share";
  direnvBin = getExe pkgs.direnv;
in {
  home.packages = with pkgs; [blesh];

  programs.bash.initExtra = mkMerge [
    (mkBefore ''
      source -- "$(${bleshShareBin})"/ble.sh --attach=none
    '')

    # Direnv should be initialized before ble-attach, or it won't work.
    (mkAfter ''
      eval "$(${direnvBin} hook bash)"
      ble-attach
    '')
  ];
}

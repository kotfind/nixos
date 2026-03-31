{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkMerge mkBefore mkAfter getExe';

  bleshShareBin = getExe' pkgs.blesh "blesh-share";
in {
  home.packages = with pkgs; [blesh];

  programs.bash.initExtra = mkMerge [
    (mkBefore ''source -- "$(${bleshShareBin})"/ble.sh --attach=none'')
    (mkAfter ''ble-attach'')
  ];
}

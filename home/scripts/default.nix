{pkgs, ...}: let
  inherit (pkgs) writeShellScriptBin;
  inherit (pkgs.writers) writePython3Bin;
in {
  home.packages = [
    (writeShellScriptBin "nolink" ./nolink.sh)
    (writePython3Bin "dir2prompt" {flakeIgnore = ["E501"];} ./dir2prompt.py)
  ];
}

{pkgs, ...}: let
  inherit (pkgs) writeShellScriptBin;
  inherit (pkgs.writers) writePython3Bin;

  notify-on-exit =
    writePython3Bin "notify-on-exit" {
      flakeIgnore = ["E265"];
      libraries = with pkgs.python3Packages; [
        click
        desktop-notifier
        platformdirs
        python-xlib
      ];
    }
    ./notify-on-exit.py;
in {
  home.packages = [
    (writeShellScriptBin "nolink" ./nolink.sh)
    (writePython3Bin "dir2prompt" {flakeIgnore = ["E501"];} ./dir2prompt.py)
    notify-on-exit
  ];
}

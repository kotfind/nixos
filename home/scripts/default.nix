{pkgs, ...}: let
  inherit (builtins) readFile;
  inherit (pkgs) writeShellScriptBin writeShellApplication;
  inherit (pkgs.writers) writePython3Bin;

  notify-on-exit = writeShellApplication {
    name = "notify-on-exit";
    text = readFile ./notify-on-exit.sh;
    runtimeInputs = with pkgs; [
      xdotool
      libnotify
    ];
  };
in {
  home.packages = [
    (writeShellScriptBin "nolink" ./nolink.sh)
    (writePython3Bin "dir2prompt" {flakeIgnore = ["E501"];} ./dir2prompt.py)
    notify-on-exit
  ];
}

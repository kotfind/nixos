{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;

  gitBin = getExe pkgs.git;
in {
  programs.bash.shellAliases = {
    gs = "${gitBin} status --short";
    ga = "${gitBin} add";
    gc = "${gitBin} commit";
    gca = "${gitBin} commit --amend";
    gp = "${gitBin} push";

    gd = "${gitBin} diff --word-diff=color";
    gdc = "${gitBin} diff --cached --word-diff=color";

    gl = "${gitBin} log --oneline";
    gt = "${gitBin} log --graph --all --oneline --decorate";

    gch = "${gitBin} checkout";
    gb = "${gitBin} branch";
    gm = "${gitBin} merge";

    root = "cd (${gitBin} rev-parse --show-toplevel)";
  };
}

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
    gc = "${gitBin} commit";
    gca = "${gitBin} commit --amend";
    gp = "${gitBin} push";

    ga = "${gitBin} add";
    gaa = "${gitBin} add :/:";

    gd = "${gitBin} diff --word-diff=color";
    gdc = "${gitBin} diff --cached --word-diff=color";
    gda = "${gitBin} diff --word-diff=color HEAD";
    gdt = "${gitBin} difftool";
    gdtc = "${gitBin} difftool";
    gdta = "${gitBin} difftool HEAD";

    gl = "${gitBin} log --oneline";
    gt = "${gitBin} log --graph --all --oneline --decorate";

    gch = "${gitBin} checkout";
    gb = "${gitBin} branch";
    gm = "${gitBin} merge";
    grb = "${gitBin} rebase";

    root = ''cd "$(${gitBin} rev-parse --show-toplevel)"'';
  };
}

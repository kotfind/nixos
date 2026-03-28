{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;

  ezaBin = getExe pkgs.eza;
  ezaBase = "${ezaBin} --group-directories-first";
in {
  programs.eza = {
    enable = true;
    enableBashIntegration = false;
  };

  programs.bash.shellAliases = {
    ls = "${ezaBase} --git-ignore";
    l = "${ezaBase} --git-ignore -hl";
    L = "${ezaBase} -ahl";
    t = "${ezaBase} --tree --git-ignore -hl";
    T = "${ezaBase} --tree -ahl";
  };
}

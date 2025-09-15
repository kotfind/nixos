{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;

  eza = "${getExe pkgs.eza} --group-directories-first --color=always";

  podman = getExe pkgs.podman;
  podman-compose = getExe pkgs.podman-compose;
in {
  programs.fish.shellAliases = {
    e = "exec";

    # won't use abs path to allow using in devShells
    p3 = "python3";

    pd = "${podman}";
    pc = "${podman-compose}";

    ls = "${eza} --git-ignore";
    l = "${eza} --git-ignore -hl";
    L = "${eza} -ahl";
    t = "${eza} --tree --git-ignore -hl";
    T = "${eza} --tree -ahl";
  };
}

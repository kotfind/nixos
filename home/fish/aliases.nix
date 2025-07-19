{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;

  eza_ = getExe pkgs.eza;
  eza = "${eza_} --group-directories-first --color=always";

  podman = getExe pkgs.podman;
  podman-compose = getExe pkgs.podman-compose;
in {
  p3 = "python3";
  e = "exec";

  pd = "${podman}";
  pc = "${podman-compose}";

  ls = "${eza} --git-ignore";
  l = "${eza} --git-ignore -hl";
  L = "${eza} -ahl";
  t = "${eza} --tree --git-ignore -hl";
  T = "${eza} --tree -ahl";
}

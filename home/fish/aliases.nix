{ pkgs, ... }:

# Common
{
    p3 = "${pkgs.python3}/bin/python3";
    e = "exec";
}

# Eza
// (let
    eza = "${pkgs.eza}/bin/eza --group-directories-first --color=always";
in
{
    ls = "${eza} --git-ignore";
    l  = "${eza} --git-ignore -hl";
    L  = "${eza} -ahl";
    t  = "${eza} --tree --git-ignore -hl";
    T  = "${eza} --tree -ahl";
})

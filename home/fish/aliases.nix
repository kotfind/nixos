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

# Git
// (let
    git = "${pkgs.git}/bin/git";
in
{
    gs   = "${git} status --short";
    ga   = "${git} add";
    gc   = "${git} commit";
    gca  = "${git} commit --amend";
    gp   = "${git} push";
    gd   = "${git} diff --word-diff=color";
    gdc  = "${git} diff --cached --word-diff=color";
    gl   = "${git} log --oneline";
    gt   = "${git} log --graph --all --oneline --decorate";
    gch  = "${git} checkout";
    gb   = "${git} branch";
    gm   = "${git} merge";
    root = "cd (${git} rev-parse --show-toplevel)";
})

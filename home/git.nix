{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;

    userName = with config.cfgLib;
      enableFor users.kotfind
      users.kotfind.name;

    userEmail = with config.cfgLib;
      enableFor users.kotfind
      users.kotfind.data.email;

    extraConfig = {
      core.quotepath = false;
    };

    difftastic.enable = true;
  };

  home.packages =
    (with config.cfgLib; enableFor users.kotfind)
    (with pkgs; [
      gh
    ]);

  sops = let
    token_secret = "kotfind/gh/oauth_token";
  in {
    secrets = (with config.cfgLib; enableFor users.kotfind) {
      ${token_secret} = {};
    };

    templates.gh_hosts = {
      content = let
        oauth_token = "${config.sops.placeholder.${token_secret}}";
      in
        /*
        yaml
        */
        ''
          github.com:
              users:
                  kotfind:
                      oauth_token: ${oauth_token}
              git_protocol: ssh
              user: kotfind
              oauth_token: ${oauth_token}
        '';

      path =
        (with config.cfgLib; enableFor users.kotfind)
        "${config.home.homeDirectory}/.config/gh/hosts.yml";
    };
  };

  programs.fish.shellAliases = let
    git = lib.getExe pkgs.git;
  in {
    gs = "${git} status --short";
    ga = "${git} add";
    gc = "${git} commit";
    gca = "${git} commit --amend";
    gp = "${git} push";
    gd = "${git} diff --word-diff=color";
    gdc = "${git} diff --cached --word-diff=color";
    gl = "${git} log --oneline";
    gt = "${git} log --graph --all --oneline --decorate";
    gch = "${git} checkout";
    gb = "${git} branch";
    gm = "${git} merge";
    root = "cd (${git} rev-parse --show-toplevel)";
  };
}

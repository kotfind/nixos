{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config) sops;
  inherit (config.cfgLib) users enableFor matchFor;
  inherit (config.home) homeDirectory;
  inherit (lib) getExe;
in {
  programs.git = {
    enable = matchFor users.kotfind;

    settings = {
      user = with users.kotfind; {
        inherit name;
        inherit (data) email;
      };

      extraConfig = {
        core.quotepath = false;
      };
    };
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
  };

  programs.lazygit = {
    enable = true;
    enableFishIntegration = true;
  };

  home.packages =
    enableFor users.kotfind
    (with pkgs; [
      gh
    ]);

  sops = {
    secrets = enableFor users.kotfind {
      "kotfind/gh/oauth_token" = {};
    };

    templates.gh_hosts = {
      content = ''
        github.com:
          users:
            kotfind:
              oauth_token: ${sops.placeholder."kotfind/gh/oauth_token"}
          git_protocol: ssh
          user: kotfind
          oauth_token: ${sops.placeholder."kotfind/gh/oauth_token"}
      '';

      path =
        enableFor users.kotfind
        "${homeDirectory}/.config/gh/hosts.yml";
    };
  };

  programs.fish.shellAliases = let
    git = getExe pkgs.git;
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

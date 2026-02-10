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

  ph = sops.placeholder;
in {
  programs.git = {
    enable = matchFor users.kotfind;

    settings = {
      core = {
        quotePath = false;
      };

      user = with users.kotfind; {
        inherit name;
        inherit (data) email;
      };

      push = {
        autoSetupRemote = true;
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
      gh_oauth_token = {
        sopsFile = ./gh_oauth_token.enc;
        format = "binary";
      };
    };

    templates.gh_hosts = {
      content = enableFor users.kotfind ''
        github.com:
          users:
            kotfind:
              oauth_token: ${ph.gh_oauth_token}
          git_protocol: ssh
          user: kotfind
          oauth_token: ${ph.gh_oauth_token}
      '';

      path = enableFor users.kotfind "${homeDirectory}/.config/gh/hosts.yml";
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

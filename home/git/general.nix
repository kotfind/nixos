{
  config,
  pkgs,
  ...
}: let
  inherit (config) sops;
  inherit (config.cfgLib) users enableFor matchFor;
  inherit (config.home) homeDirectory;

  ph = sops.placeholder;
in {
  programs.git = {
    enable = matchFor users.kotfind;

    signing.format = null;

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

      init.defaultBranch = "master";

      diff.tool = "nvimdiff";
    };
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
  };

  programs.lazygit.enable = true;

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
}

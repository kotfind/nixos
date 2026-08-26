{
  config,
  pkgs,
  ...
}: let
  inherit (config) sops;
  inherit (config.hostlib) users mkFor trueFor;
  inherit (config.home) homeDirectory;

  ph = sops.placeholder;
in {
  programs.git = {
    enable = trueFor users.kotfind;

    signing.format = null;

    lfs.enable = true;

    settings = {
      core = {
        quotePath = false;
      };

      user = with users.kotfind; {
        inherit name;
        inherit email;
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
    mkFor users.kotfind
    (with pkgs; [
      gh
    ]);

  sops = {
    secrets = {
      gh_oauth_token = {
        sopsFile = ./gh_oauth_token.enc;
        format = "binary";
      };
    };

    templates.gh_hosts = {
      content = ''
        github.com:
          users:
            kotfind:
              oauth_token: ${ph.gh_oauth_token}
          git_protocol: ssh
          user: kotfind
          oauth_token: ${ph.gh_oauth_token}
      '';

      path = mkFor users.kotfind "${homeDirectory}/.config/gh/hosts.yml";
    };
  };
}

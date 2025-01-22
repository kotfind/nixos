{ pkgs, config, cfg, ... }:
{
    sops = {
        age = {
            sshKeyPaths = [];
            keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        };

        defaultSopsFile = ./default.yaml;

        secrets =
            {
                kotfindPC-ip-address = {};
            } //
            (if cfg.fullname == "kotfind@kotfindPC" then {
                "kotfind@kotfindPC/ssh/id_rsa".path = "/home/kotfind/.ssh/id_rsa";
                "kotfind@kotfindPC/ssh/id_rsa.pub".path = "/home/kotfind/.ssh/id_rsa.pub";
            } else {}) //
            (if cfg.username == "kotfind" then {
                "kotfind/gh/oauth_token" = {};
            } else {});

        templates =
            {
            } //
            (if cfg.username == "kotfind" then {
                "gh_hosts" = {
                    content = let
                        oauth_token = "${config.sops.placeholder."kotfind/gh/oauth_token"}";
                    in ''
                        github.com:
                            users:
                                kotfind:
                                    oauth_token: ${oauth_token}
                            git_protocol: ssh
                            user: kotfind
                            oauth_token: ${oauth_token}
                    '';
                    path = "/home/kotfind/.config/gh/hosts.yml";
                };
            } else {});
    };

    home.packages = with pkgs; [
        sops
        age
    ];

    programs.bash.bashrcExtra = ''
        export kotfindPC="''$(cat ${config.sops.secrets.kotfindPC-ip-address.path})"
    '';
}

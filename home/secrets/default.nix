{ pkgs, config, lib, ... }:
{
    sops = {
        age = {
            sshKeyPaths = [];
            keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        };

        defaultSopsFile = ./default.yaml;

        # TODO: move secret definitions closer to their uses
        secrets = lib.mkMerge [
            {
                kotfindPC-ip-address = {};
            }   
            ((with config.cfgLib; enableFor hosts.pc.users.kotfind) {
                "kotfind@kotfindPC/ssh/id_rsa".path = "/home/kotfind/.ssh/id_rsa";
                "kotfind@kotfindPC/ssh/id_rsa.pub".path = "/home/kotfind/.ssh/id_rsa.pub";
            })
            ((with config.cfgLib; enableFor users.kotfind) {
                "kotfind/gh/oauth_token" = {};
            })
        ];

        templates = {
            gh_hosts = {
                content = let
                        oauth_token = "${config.sops.placeholder."kotfind/gh/oauth_token"}";
                    in
                    /* yaml */ ''
                        github.com:
                            users:
                                kotfind:
                                    oauth_token: ${oauth_token}
                            git_protocol: ssh
                            user: kotfind
                            oauth_token: ${oauth_token}
                    '';

                path = (with config.cfgLib; enableFor users.kotfind)
                    "${config.home.homeDirectory}/.config/gh/hosts.yml";
            };
        };
    };

    home.packages = with pkgs; (with config.cfgLib; enableFor users.kotfind) [
            sops
            age
        ];

    programs.bash.bashrcExtra = (with config.cfgLib; enableFor users.kotfind)
        /* bash */ ''
            export kotfindPC="''$(cat ${config.sops.secrets.kotfindPC-ip-address.path})"
        '';
}

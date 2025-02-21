{ config, lib, pkgs, ... }:
{
    # XXX: secrets are installed for all users, though files
    # are linked correctly
    sops.secrets = {
        kotfindPC-ip-address = {};

        "kotfind@kotfindPC/ssh/id_rsa" = {
            path = (with config.cfgLib; enableFor hosts.pc.users.kotfind)
                "${config.home.homeDirectory}/.ssh/id_rsa";
        };

        "kotfind@kotfindPC/ssh/id_rsa.pub" = {
            path = (with config.cfgLib; enableFor hosts.pc.users.kotfind)
                "${config.home.homeDirectory}/.ssh/id_rsa.pub";
        };

        "kotfind@kotfindLT/ssh/id_rsa" = {
            path = (with config.cfgLib; enableFor hosts.laptop.users.kotfind)
                "${config.home.homeDirectory}/.ssh/id_rsa";
        };

        "kotfind@kotfindLT/ssh/id_rsa.pub" = {
            path = (with config.cfgLib; enableFor hosts.laptop.users.kotfind)
                "${config.home.homeDirectory}/.ssh/id_rsa.pub";
        };
    };

    programs.ssh = (with config.cfgLib; enableFor users.kotfind) {
        enable = true;
    };

    programs.bash.bashrcExtra = (with config.cfgLib; enableFor users.kotfind)
        /* bash */ ''
            export kotfindPC="''$(cat ${
                lib.escapeShellArg
                    config.sops.secrets.kotfindPC-ip-address.path
            })"
        '';

    sops.templates.kotfindPCEnvFile = {
        content = ''
            kotfindPC=${lib.escapeShellArg config.sops.placeholder.kotfindPC-ip-address}
        '';
    };

    # XXX: quite a lot of hardcoded stuff here
    systemd.user.mounts = (with config.cfgLib; enableFor hosts.laptop.users.kotfind) {
        home-kotfind-pc = {
            Mount = {
                Environment = [ "PATH=${lib.strings.makeBinPath [pkgs.sshfs]}" ];
                EnvironmentFile = config.sops.templates.kotfindPCEnvFile.path;
                What = "kotfind@%v/kotfindPC:/home/kotfind";
                Where = "${config.home.homeDirectory}/pc";
                Type = "fuse.sshfs";
                Options = [
                    "nodev"
                    "noatime"
                    "IdentityFile=${config.home.homeDirectory}/.ssh/id_rsa"
                    "reconnect"
                ];
            };

            Install = {
                WantedBy = [ "default.target" ];
            };

            Unit = {
                Wants = [ "default.target" ];
                After = [ "default.target" ];
            };
        };
    };
}

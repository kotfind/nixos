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
}

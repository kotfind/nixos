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

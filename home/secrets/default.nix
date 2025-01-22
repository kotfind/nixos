{ pkgs, config, ... }:
{
    sops = {
        age = {
            sshKeyPaths = [];
            keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        };
        defaultSopsFile = ./default.yaml;
        secrets = {
            kotfindPC-ip-address = {};
        };
    };

    home.packages = with pkgs; [
        sops
        age
    ];

    programs.bash.bashrcExtra = ''
        export kotfindPC="''$(cat ${config.sops.secrets.kotfindPC-ip-address.path})"
    '';
}

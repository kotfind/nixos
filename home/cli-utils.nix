{ config, pkgs, lib, ... }:
{
    home.packages = with pkgs; lib.mkMerge [
        [
            wget
            curl
            killall
            p7zip
            bat
            ncdu
            file
            xclip
            cloc
            imagemagick
            ffmpeg
            age
        ]

        ((with config.cfgLib; enableFor users.kotfind)  [
            gh
        ])
    ];

    programs = {
        man.enable = true;
        fd.enable = true;
        ripgrep.enable = true;
        jq.enable = true;

        git = with config.cfgLib; enableFor users.kotfind {
            enable = true;
            userName = users.kotfind.name;
            userEmail = users.kotfind.data.email;

            extraConfig = {
                core.quotepath = false;
            };

            difftastic.enable = true;
        };

        # TODO: fixme
        # gh = {
        #     enable = true;
        #     settings.git_protocol = "ssh";
        # };

        htop = {
            enable = true;

            # TODO: configure
        };

        direnv = with config.cfgLib; enableFor users.kotfind {
            enable = true;
            nix-direnv.enable = true;
        };
    };
}

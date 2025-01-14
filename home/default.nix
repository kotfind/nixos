{ ... }:
{
    imports = [
        ./fish
        ./alacritty
    ];

    home = {
        stateVersion = "24.11";

        # username = cfg.username;
        # homeDirectory = "/home/${cfg.username}";

        username = "kotfind";
        homeDirectory = "/home/kotfind";
    };


    programs.home-manager.enable = true;
}

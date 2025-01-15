{ cfg, ... }:
{
    imports = [
        ./fish
        ./alacritty
    ];

    home = {
        stateVersion = "24.11";

        username = cfg.username;
        homeDirectory = "/home/${cfg.username}";
    };


    programs.home-manager.enable = true;
}

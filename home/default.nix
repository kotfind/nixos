{ cfg, ... }:
{
    imports = [
        ./X11
        ./alacritty
        ./fcitx5.nix
        ./fish
        ./mime
        ./nvim
        ./rust
        ./sqlite
        ./tmux
    ];

    home = {
        stateVersion = "24.11";

        username = cfg.username;
        homeDirectory = "/home/${cfg.username}";
    };


    programs.home-manager.enable = true;
}

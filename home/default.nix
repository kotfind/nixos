{ pkgs, cfg, ... }:
{
    imports = [
        ./X11
        ./alacritty
        ./chromium.nix
        ./cli-utils.nix
        ./firefox.nix
        ./fish
        ./fonts.nix
        ./gui-utils.nix
        ./keyboard.nix
        ./mime
        ./nvim
        ./pass.nix
        ./proxy.nix
        ./rust
        ./sqlite
        ./tmux

        # pkgs.libs.lists.optionals (cfg.fullname == "kotfind@kotfindPC") [ ./gallery-dl.nix ]
    ];

    home = {
        stateVersion = "24.11";

        username = cfg.username;
        homeDirectory = "/home/${cfg.username}";
    };


    programs.home-manager.enable = true;
}

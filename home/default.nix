{ config, ... }:
{
    imports = [
        # ./xorg
        # ./alacritty
        # ./chromium.nix
        # ./cli-utils.nix
        # ./firefox.nix
        # ./fish
        # ./fonts.nix
        # ./gui-utils.nix
        # ./keyboard
        # ./mime.nix
        # ./nvim
        # ./pass.nix
        # ./proxy.nix
        # ./rust.nix
        # ./sqlite.nix
        # ./tmux
        # ./gallery-dl.nix
        # ./secrets
        # ./scripts
    ];

    home = {
        stateVersion = "24.11";

        # username = cfg.username;
        homeDirectory = if config.home.username == "kotfind"
            then "/home/kotfind"
            else "/root";
    };


    programs.home-manager.enable = true;
}

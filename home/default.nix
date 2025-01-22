{ cfg, ... }:
{
    imports = [
        ./xorg
        ./alacritty
        ./chromium.nix
        ./cli-utils.nix
        ./firefox.nix
        ./fish
        ./fonts.nix
        ./gui-utils.nix
        ./keyboard
        ./mime
        ./nvim
        ./pass.nix
        ./proxy.nix
        ./rust
        ./sqlite
        ./tmux
        ./obs.nix
        ./gallery-dl.nix
        ./secrets
    ];

    home = {
        stateVersion = "24.11";

        username = cfg.username;
        homeDirectory = "/home/${cfg.username}";
    };


    programs.home-manager.enable = true;
}

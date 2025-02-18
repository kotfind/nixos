{ config, ... }:
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
        ./mime.nix
        ./nvim
        ./pass.nix
        ./proxy.nix
        ./rust.nix
        ./sqlite.nix
        ./tmux
        ./gallery-dl.nix
        ./secrets
        ./scripts
    ];

    home = {
        stateVersion = "24.11";

        homeDirectory =
            let
                user = config.cfgLib.user;
            in
            user.data.homeDir or "/home/${user.name}";

    };

    programs.home-manager.enable = true;
}

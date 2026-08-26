{config, ...}: let
  inherit (config.hostlib) _curUser;
in {
  imports = [
    ./ai
    ./alacritty
    ./backup.nix
    ./bash
    ./beet.nix
    ./bluetooth.nix
    ./cli-utils.nix
    ./downloaders.nix
    ./eza.nix
    ./firefox.nix
    ./fonts.nix
    ./git
    ./gui-utils.nix
    ./keyboard
    ./mail.nix
    ./mime.nix
    ./nix-docs.nix
    ./nvim
    ./pass.nix
    ./rust.nix
    ./scripts
    ./secrets
    ./sqlite.nix
    ./ssh.nix
    ./tmux
    ./topiary
    ./xorg
  ];

  home = {
    stateVersion = "24.11";

    username = _curUser.name;

    homeDirectory = _curUser.homeDir or "/home/${_curUser.name}";
  };

  programs.home-manager.enable = true;
}

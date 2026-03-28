{config, ...}: let
  inherit (config.cfgLib) user;
in {
  imports = [
    # ./fish
    ./alacritty
    ./backup.nix
    ./bash
    ./beet.nix
    ./cli-utils.nix
    ./downloaders.nix
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

    homeDirectory = user.data.homeDir or "/home/${user.name}";
  };

  programs.home-manager.enable = true;
}

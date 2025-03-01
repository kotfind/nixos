{config, ...}: {
  imports = [
    ./alacritty
    ./chromium.nix
    ./cli-utils.nix
    ./firefox.nix
    ./fish
    ./fonts.nix
    ./gallery-dl.nix
    ./git.nix
    ./gui-utils.nix
    ./keyboard
    ./mime.nix
    ./nvim
    ./pass.nix
    ./proxy.nix
    ./rust.nix
    ./scripts
    ./secrets
    ./sqlite.nix
    ./ssh.nix
    ./tmux
    ./xorg
  ];

  home = {
    stateVersion = "24.11";

    homeDirectory = let
      user = config.cfgLib.user;
    in
      user.data.homeDir or "/home/${user.name}";
  };

  programs.home-manager.enable = true;
}

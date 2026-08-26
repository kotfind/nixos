{config, ...}: {
  # TODO: rewrite with nix
  home.file.".tmux.conf" = (with config.hostlib; mkFor users.kotfind) {
    source = ./.tmux.conf;
  };

  programs.tmux = (with config.hostlib; mkFor users.kotfind) {
    enable = true;
  };
}

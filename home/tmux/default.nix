{ config, ... }:
{
    # TODO: rewrite with nix
    home.file.".tmux.conf" = (with config.cfgLib; enableFor users.kotfind) {
        source = ./.tmux.conf;
    };

    programs.tmux = (with config.cfgLib; enableFor users.kotfind) {
        enable = true;
    };
}

{ config, pkgs, ... }:
{
    home.file.".sqliterc" = (with config.cfgLib; enableFor users.kotfind) {
        text = ''
            .mode box
            .nullvalue ∅
        '';
    };

    home.packages = (with config.cfgLib; enableFor users.kotfind) [
        pkgs.sqlite
    ];
}

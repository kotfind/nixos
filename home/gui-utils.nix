{ pkgs, ... }:
{
    home.packages = with pkgs; [
        vlc
        vlc-bittorrent # TODO: won't work
        transmission_4-qt
        sxiv
        telegram-desktop
    ];
}

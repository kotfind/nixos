{ pkgs, ... }:
{
    home.packages = with pkgs; [
        vlc
        vlc-bittorrent # TODO: won't work
        transmission_4-qt
        sxiv

        pavucontrol

        # Run this to make fcitx5 to work in telegram
        # sudo dbus-update-activation-environment --all
        # source: https://github.com/telegramdesktop/tdesktop/issues/26891
        telegram-desktop
    ];

    programs.zathura.enable = true;
}

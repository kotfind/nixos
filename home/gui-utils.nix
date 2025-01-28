{ pkgs, ... }:
{
    home.packages = with pkgs; [
        # Run this to make fcitx5 to work in telegram
        #   sudo dbus-update-activation-environment --all
        # or run telegram from terminal:
        #   telegram-desktop & disown & exit
        # source: https://github.com/telegramdesktop/tdesktop/issues/26891
        telegram-desktop

        vlc
        transmission_4-qt
        sxiv
        pavucontrol
        libreoffice
    ];

    programs.zathura.enable = true;
}

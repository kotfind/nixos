{ pkgs, config, ... }:
{
    home.packages = with pkgs; lib.mkMerge [
        [
            sxiv
        ]
        ((with config.cfgLib; enableFor users.kotfind) [
            # Run this to make fcitx5 to work in telegram
            #   sudo dbus-update-activation-environment --all
            # or run telegram from terminal:
            #   telegram-desktop & disown & exit
            # source: https://github.com/telegramdesktop/tdesktop/issues/26891
            telegram-desktop

            vlc
            transmission_4-qt
            pavucontrol
            libreoffice
        ])
    ];

    programs = (with config.cfgLib; enableFor users.kotfind) {
        zathura.enable = true;
        obs-studio.enable = true;
    };
}

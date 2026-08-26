{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.hostlib) join users hosts mkFor trueFor;
in {
  home.packages = with pkgs;
    lib.mkMerge [
      [
        sxiv
      ]
      (mkFor users.kotfind [
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
        pinta
        inkscape
        gimp
        localsend
        valentina
        zoom-us
        loupe
        kdePackages.gwenview
        flacon # cutting flac's
        simple-scan
        solvespace
        freecad
        webcamoid
        kicad
        tigervnc
      ])

      (mkFor hosts.laptop [
        brightnessctl
      ])

      (mkFor (join users.kotfind hosts.pc) [
        steam-run
      ])
    ];

  programs = {
    zathura.enable = trueFor users.kotfind;
    obs-studio.enable = trueFor users.kotfind;
    chromium.enable = trueFor users.kotfind;
  };
}

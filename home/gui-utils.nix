{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.hostlib) users hosts mkFor;
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
        rayforge
        webcamoid
        kicad
        tigervnc
        lutris-free
      ])

      (mkFor hosts.laptop [
        brightnessctl
      ])

      (mkFor hosts.pc [
        kdePackages.kdenlive
        steam-run
      ])
    ];

  programs = {
    zathura.enable = true;
    obs-studio.enable = true;
    chromium.enable = true;
  };
}

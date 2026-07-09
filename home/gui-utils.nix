{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.cfgLib) users hosts enableFor matchFor;
in {
  home.packages = with pkgs;
    lib.mkMerge [
      [
        sxiv
      ]
      (enableFor users.kotfind [
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
        moonlight-qt
        loupe
        kdePackages.gwenview
        flacon # cutting flac's
        freecad
        simple-scan
        solvespace
        webcamoid
        kicad
      ])

      (enableFor hosts.laptop [
        brightnessctl
      ])

      (enableFor hosts.pc.users.kotfind [
        steam-run
      ])
    ];

  programs = {
    zathura.enable = matchFor users.kotfind;
    obs-studio.enable = matchFor users.kotfind;
    chromium.enable = matchFor users.kotfind;
  };
}

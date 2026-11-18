{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.hostlib) users hosts mkFor;
  inherit (lib) mkMerge getExe;
in {
  home.packages = with pkgs;
    mkMerge [
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

        flacon # cutting flac's
        freecad
        gimp
        inkscape
        kdePackages.gwenview
        kicad
        libreoffice
        localsend
        loupe
        lutris-free
        pavucontrol
        pinta
        quadrapassel
        rayforge
        simple-scan
        solvespace
        tigervnc
        transmission_4-qt
        valentina
        vlc
        webcamoid
        zoom-us
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

  programs.bash.shellAliases = {
    tetris = getExe pkgs.quadrapassel;
  };
}

{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.cfgLib) users enableFor matchFor;
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

        # NOTE: current version from unstable is broken
        # See
        #     https://github.com/NixOS/nixpkgs/pull/348263
        # and
        #     https://github.com/NixOS/nixpkgs/issues/345314
        # Current workarround:
        #     nix run github:nixos/nixpkgs/nixos-24.05#openshot-qt
        #
        # openshot-qt

        zoom-us
      ])
    ];

  programs = {
    zathura.enable = matchFor users.kotfind;
    obs-studio.enable = matchFor users.kotfind;
  };
}

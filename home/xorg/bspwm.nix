{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) concatStringsSep genList;
  inherit (builtins) toString;
  inherit (config.cfgLib) matchFor users;
in {
  xsession.windowManager.bspwm = {
    enable = matchFor users.kotfind;

    settings = {
      border_width = 2;
      window_gap = 10;

      top_padding = 15;
      top_monocle_padding = 10;

      split_ratio = 0.5;

      gapless_monocle = true;
      single_monocle = true;

      focus_follows_pointer = true;
      pointer_follows_monitor = true;
    };

    extraConfig = let
      bspc = lib.getExe' pkgs.bspwm "bspc";
    in
      /*
      bash
      */
      ''
        monitors=($(${bspc} query -M --names))
        for monitor in "''${monitors[@]}"; do
          ${bspc} monitor "$monitor" -d ${
          concatStringsSep
          " "
          (
            genList
            (x: toString (x + 1))
            9
          )
        }
        done
      '';
  };
}

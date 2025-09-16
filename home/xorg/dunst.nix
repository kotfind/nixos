{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.cfgLib) matchFor users;
  inherit (lib) getExe getExe';
  inherit (pkgs) writeShellScriptBin;

  xkbbell = getExe' pkgs.xorg.xkbutils "xkbbell";

  just-beep = writeShellScriptBin "just-beep" ''
    ${xkbbell}
  '';

  rofi = getExe pkgs.rofi;
in {
  services.dunst = {
    enable = matchFor users.kotfind;
    settings = {
      # -------------------- General --------------------
      global = {
        # -------------------- General.Layout --------------------
        width = 350;

        padding = 5;
        horizontal_padding = 5;

        progress_bar_min_width = 10000;
        progress_bar_max_width = 10000;

        # -------------------- General.Positioning --------------------
        origin = "bottom-right";
        offset = "(5, 5)";

        gap_size = 5;

        # -------------------- General.Actions --------------------
        mouse_left_click = "do_action,close_current";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";

        # -------------------- General.Looks --------------------
        background = "#000000";
        foreground = "#ffffff";

        min_icon_size = 80;
        max_icon_size = 80;

        line_height = 1;

        font = "DejaVu Sans";

        # -------------------- General.Other --------------------
        notification_limit = 7;

        enable_posix_regex = true;

        dmenu = "${rofi} -dmenu -p dunst";
      };

      # -------------------- Rules --------------------

      # NOTE: Some of the rules are named in `{number}-{name}` style.
      # NOTE: This enforces their order in resulting config file.

      # -------------------- Rules.Urgencies --------------------
      "00-urgency-critical" = {
        msg_urgency = "critical";

        fullscreen = "show";
        frame_color = "#ff0000";

        timeout = "0s";
      };

      "00-urgency-normal" = {
        msg_urgency = "normal";

        fullscreen = "delay";
        frame_color = "#dddddd";
      };

      "00-urgency-low" = {
        msg_urgency = "low";

        fullscreen = "delay";
        frame_color = "#999999";
      };

      # -------------------- Rules.Custom --------------------
      fcitx5 = {
        appname = "^Input Method$";

        skip_display = true;
        history_ignore = true;
      };

      volume = {
        appname = "^volume$";

        new_icon = "${./icons/volume.svg}";
        min_icon_size = 50;
        max_icon_size = 50;

        set_stack_tag = 0;
        timeout = "1s";
      };

      volume-muted = {
        appname = "^volume-muted$";

        new_icon = "${./icons/volume-muted.svg}";
        min_icon_size = 50;
        max_icon_size = 50;

        set_stack_tag = 0;
        timeout = "1s";
      };

      brightnes = {
        appname = "^brightness$";

        new_icon = "${./icons/brightness.svg}";
        min_icon_size = 50;
        max_icon_size = 50;

        set_stack_tag = 0;
        timeout = "1s";
      };

      fish-command-executed = {
        appname = "^fish-command-executed$";

        new_icon = "${./icons/cmd.svg}";
        min_icon_size = 50;
        max_icon_size = 50;

        script = "${getExe just-beep}";

        timeout = "5s";
      };

      # TODO: batsignal icons
    };
  };

  home.packages = with pkgs; [
    libnotify
  ];
}

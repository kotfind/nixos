{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (pkgs) writeShellScript;
  inherit (config.cfgLib) matchFor users;
  inherit (lib) getExe getExe';

  xkbbellBin = getExe' pkgs.xkbutils "xkbbell";
  rofiBin = getExe pkgs.rofi;

  # suppresses cli args, provided by dunst
  beepBin = writeShellScript "beep" xkbbellBin;
in {
  services.dunst = {
    enable = matchFor users.kotfind;
    settings = {
      # -------------------- Global --------------------

      # NOTE: It seems, that `global` section can override stuff,
      # provided in the rules. So every global setting, that
      # can be specified with a rule, should be defined in
      # `00-global` instead of normal `global`.

      "global" = {
        # -------------------- Global.Layout --------------------

        width = 350;

        padding = 5;
        horizontal_padding = 5;

        frame_width = 2;

        progress_bar_min_width = 10000;
        progress_bar_max_width = 10000;

        min_icon_size = 64;
        max_icon_size = 64;

        line_height = 1;

        font = "DejaVu Sans 11";

        # -------------------- Global.Positioning --------------------

        origin = "bottom-right";
        offset = "(5, 5)";

        gap_size = 5;

        # -------------------- Global.Actions --------------------

        mouse_left_click = "do_action,close_current";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";

        # -------------------- Global.Other --------------------

        notification_limit = 7;

        enable_posix_regex = true;

        dmenu = "${rofiBin} -dmenu -p dunst";
      };

      "00-global" = {
        # -------------------- Global.Looks --------------------

        background = "#000000";
        foreground = "#ffffff";
      };

      # -------------------- Rules --------------------

      # NOTE: Some of the rules are named in `{number}-{name}` style.
      # NOTE: This enforces their order in resulting config file.

      # -------------------- Rules.Urgencies --------------------

      "01-urgency-critical" = {
        msg_urgency = "critical";

        fullscreen = "show";
        frame_color = "#ff0000";

        timeout = "0s";
      };

      "01-urgency-normal" = {
        msg_urgency = "normal";

        fullscreen = "delay";
        frame_color = "#dddddd";
      };

      "01-urgency-low" = {
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

      # -------------------- Rules.notify-on-finish --------------------

      command-executed = {
        appname = "^command-executed$";

        new_icon = "${./icons/cmd-ok.svg}";
        min_icon_size = 50;
        max_icon_size = 50;

        script = "${beepBin}";

        timeout = "5s";
      };

      command-failed = {
        appname = "^command-failed$";

        foreground = "#ff0000";

        new_icon = "${./icons/cmd-fail.svg}";
        min_icon_size = 50;
        max_icon_size = 50;

        script = "${beepBin}";

        timeout = "5s";
      };

      # TODO: batsignal icons
    };
  };

  home.packages = with pkgs; [
    libnotify
  ];
}

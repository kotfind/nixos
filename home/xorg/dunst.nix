{
  pkgs,
  config,
  ...
}: let
  inherit (config.cfgLib) matchFor users;
in {
  services.dunst = {
    enable = matchFor users.kotfind;
    settings = {
      # -------------------- General --------------------
      global = {
        # -------------------- General.Layout --------------------
        width = 300;

        padding = 5;
        horizontal_padding = 5;

        # -------------------- General.Positioning --------------------
        origin = "bottom-right";
        offset = "(5, 5)";

        gap_size = 5;

        # -------------------- General.Actions --------------------
        mouse_left_click = "do_action,close_current";
        mouse_middle_click = "close_all";
        mouse_middle_right = "close_current";

        # -------------------- General.Looks --------------------
        background = "#000000";
        foreground = "#ffffff";

        font = "DejaVu Sans";

        # -------------------- General.Other --------------------
        notification_limit = 7;

        enable_posix_regex = true;
      };

      # -------------------- Urgencies --------------------
      urgency_critical = {
        fullscreen = "show";
        frame_color = "#ff0000";

        timeout = 0;
      };

      urgency_normal = {
        fullscreen = "delay";
        frame_color = "#dddddd";
      };

      urgency_low = {
        fullscreen = "delay";
        frame_color = "#999999";
      };

      # -------------------- Custom Rules --------------------
      ignore-fcitx5 = {
        appname = "fcitx5";

        skip_display = true;
        history_ignore = true;
      };
    };
  };

  home.packages = with pkgs; [
    libnotify
  ];
}

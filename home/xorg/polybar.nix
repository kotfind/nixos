{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (pkgs) writeShellScript;
  inherit (lib) getExe;
  inherit (config.cfgLib) matchFor users;

  xrandrBin = getExe pkgs.xrandr;
  awkBin = getExe pkgs.gawk;
  pavucontrolBin = getExe pkgs.pavucontrol;
  alacrittyBin = getExe pkgs.alacritty;
  htopBin = getExe pkgs.htop;

  htopByMemBin = writeShellScript "htop-by-mem" ''
    ${alacrittyBin} -e ${htopBin} -s PERCENT_MEM
  '';

  htopByCpuBin = writeShellScript "htop-by-cpu" ''
    ${alacrittyBin} -e ${htopBin} -s PERCENT_CPU
  '';

  fg = "#ffffff";
  bg = "#000000";

  pale = "#dddddd";
  crit = "#ff0000";
in {
  services.polybar = {
    enable = matchFor users.kotfind;

    package = pkgs.polybar.override {
      pulseSupport = true;
    };

    script = ''
      set -euo pipefail

      readarray -t monitors \
        < <(${xrandrBin} --listactivemonitors | ${awkBin} 'NR>1 { print $4; }')

      for monitor in "''${monitors[@]}"
      do
        MONITOR="$monitor" polybar master &
      done
    '';

    settings = {
      # -------------------- General --------------------

      settings = {
        format-underline = fg;
      };

      # -------------------- Bar --------------------

      "bar/master" = {
        monitor = "\${env:MONITOR}";

        width = "100%";
        height = 23;

        foreground = fg;
        background = bg;

        margin-bottom = 1;
        module-margin = 1;

        underline-size = 1;
        overline-size = 1;

        font-0 = "FiraCode Nerd Font:size=12;2";

        wm-restack = "ewmh";
      };

      # -------------------- Left --------------------

      "bar/master".modules-left = "bspwm";

      "module/bspwm" = {
        type = "internal/bspwm";

        occupied-scroll = true;

        format = "<label-state>";
        format-underline = bg;

        label-focused = "%name%";
        label-focused-padding = 1;
        label-focused-foreground = bg;
        label-focused-background = fg;

        label-occupied = "%name%";
        label-occupied-padding = 1;
        label-occupied-underline = fg;

        label-empty = "%name%";
        label-empty-padding = 1;

        label-urgent = "%name%";
        label-urgent-padding = 1;
      };

      # -------------------- Center --------------------

      "bar/master".modules-center = "";

      # -------------------- Right --------------------

      "bar/master".modules-right = "time battery brightness volume cpu memory tray";

      "module/time" = {
        type = "internal/date";

        label = " %date%%time%";

        date = "%Y-%m-%d ";
        time = "%H:%M:%S";

        date-alt = "";
        time-alt = "%s";
      };

      "module/battery" = {
        type = "internal/battery";

        battery = "BAT0";
        adapter = "AC0";

        poll-interval = 1;

        format-charging = "<label-charging>";
        format-discharging = "<label-discharging>";

        label-charging = "󰢟 %percentage%%";
        label-discharging = "󰂎 %percentage%%";
      };

      "module/brightness" = {
        type = "internal/backlight";

        card = "intel_backlight";

        enable-scroll = true;

        format = "<label>";

        label = " %percentage%%";
      };

      "module/volume" = {
        type = "internal/pulseaudio";

        format-volume = "<label-volume>";
        format-muted = "<label-muted>";

        label-volume = "󰕾%percentage:3:3%%";

        label-muted = "󰖁%percentage:3:3%%";
        label-muted-foreground = pale;
        label-muted-underline = pale;

        click-right = pavucontrolBin;

        interval = 1;
      };

      "module/cpu" = rec {
        type = "internal/cpu";

        format = "%{A3:${htopByCpuBin}:}<label>%{A}";
        format-warn = "%{A3:${htopByCpuBin}:}<label-warn>%{A}";

        label = "%percentage:3:3%%";

        label-warn = label;
        label-warn-foreground = crit;
        label-warn-underline = crit;

        click-right = ''${alacrittyBin} -e '${htopBin} -s "PERCENT_CPU"' '';
      };

      "module/memory" = rec {
        type = "internal/memory";

        warn-percentage = 80;

        format = "%{A3:${htopByMemBin}:}<label>%{A}";
        format-warn = "%{A3:${htopByMemBin}:}<label-warn>%{A}";

        label = "%percentage_used:3:3%% 󱛟%percentage_swap_used:3:3%%";

        label-warn = label;
        label-warn-foreground = crit;
        label-warn-underline = crit;
      };

      "module/tray" = {
        type = "internal/tray";

        format = "󱊖 <tray>";

        tray-spacing = 2;
        tray-size = 20;
      };
    };
  };
}

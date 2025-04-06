{
  config,
  lib,
  pkgs,
  ...
}: let
  autostartService = import ./autostart-service.nix {inherit lib;};

  date = "${pkgs.toybox}/bin/date";
  echo = "${pkgs.toybox}/bin/echo";
  top = "${pkgs.toybox}/bin/top";
  grep = "${pkgs.toybox}/bin/grep";
  printf = "${pkgs.toybox}/bin/printf";
  sleep = "${pkgs.toybox}/bin/sleep";
  free = "${pkgs.toybox}/bin/free";
  sed = "${pkgs.toybox}/bin/sed";
  cat = "${pkgs.toybox}/bin/cat";
  bspc = "${pkgs.bspwm}/bin/bspc";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  xtitle = lib.getExe pkgs.xtitle;
  awk = lib.getExe pkgs.gawk;
  xrandr = lib.getExe pkgs.xorg.xrandr;
  trayer = lib.getExe pkgs.trayer;
  lemonbar = lib.getExe pkgs.lemonbar-xft;
  bash = pkgs.runtimeShell;

  lemonbarScript = pkgs.writeShellScriptBin "lemonbar-script" ''
    set -Eeuo pipefail

    clock() {
        local date
        date="$(${date} "+%F %T")"
        ${echo} -en "\uf017 $date"
    }

    window_title() {
        local wid
        wid="$(${bspc} query -N -n .focused)"

        local title
        title="$(${xtitle} "$wid")"

        ${echo} -n "$title"
    }

    cpu_usage() {
        local cpu
        cpu="$(${top} -b -n 1 \
            | ${grep} 'Cpu' \
            | ${awk} '{ printf "%2.0f", $2 }')"

        ${echo} -en "\uf2db $cpu%"
    }

    mem_usage() {
        local mem
        mem="$(${free} \
            | ${grep} 'Mem' \
            | ${awk} '{ printf("%2.0f", $3 / $2 * 100.0) }')"

        local swap
        swap="$(${free} \
            | ${grep} 'Swap' \
            | ${awk} '{ printf("%2.0f", $3 / $2 * 100.0) }')"

        ${echo} -ne "\uf1c0 $mem% ($swap%)"
    }

    battery() {
    ${
      if (with config.cfgLib; matchFor hosts.laptop)
      then
        /*
        bash
        */
        ''
          capacity="$(${cat} /sys/class/power_supply/BAT0/capacity)"
          printf "B: %2d%%" "$capacity"
        ''
      else
        /*
        bash
        */
        ''
          ${echo} -en "NOBAT"
        ''
    }
    }

    volume() {
        if ${pactl} get-sink-mute @DEFAULT_SINK@ | ${grep} 'yes' &>/dev/null; then
            ${echo} -en ' MUTE '
        else
            local volume
            volume="$(${pactl} get-sink-volume @DEFAULT_SINK@ \
                | ${awk} '/Volume:/ { printf("%3s", $5); }')"

            ${printf} "V: %s" "$volume"
        fi
    }

    desktops() {
        local desktops
        desktops=($(${bspc} query -D -m .focused --names))
        local current_desktop
        current_desktop="$(${bspc} query -D -d .focused --names)"

        for desktop in "''${desktops[@]}"; do
            local text="$desktop"

            if ${bspc} query -N -d "$desktop" >/dev/null; then
                text+='*'
            else
                text+=' '
            fi

            if [ "$desktop" == "$current_desktop" ]; then
                text="[$text]"
            else
                text=" $text "
            fi

            ${echo} -n "%{A:${bspc} desktop $desktop -f:}$text%{A}"
        done
    }

    fmt() {
        local left
        left="$(desktops)"

        local center="" #"$(window_title)"

        local right
        right="[ $(battery) ] [ $(volume) ] [ $(clock) ] [ $(cpu_usage) ] [ $(mem_usage) ]"

        ${echo} "%{l}$left %{c}$center %{r}$right"
    }

    # -------------------- Implementation --------------------

    fonts=(
        'FiraCode'
        'FiraCode Nerd Font'
        'FiraCode Nerd Font Mono'
    )

    sleep_for=0.1

    height=20

    bar_width=150

    cfg() {
        while true; do
            fmt
            ${sleep} "$sleep_for"
        done
    }

    bar_width() {
        local screen_width
        screen_width="$(${xrandr} -q \
            | ${sed} -n 's/^.*current \([0-9]*\) x [0-9]*.*$/\1/p')"

        ${echo} $((screen_width - bar_width - 5))
    }

    run_trayer() {
        ${trayer} \
            --edge top \
            --align right \
            --widthtype pixel \
            --width "$bar_width" \
            --height "$height" \
            --tint 0x292b2e \
            --transparent true \
            --expand true \
            --alpha 0 \
            --SetDockType true \
            >/dev/null 2>&1
    }

    run() {
        local argv=()

        for font in "''${fonts[@]}"; do
            argv+=('-f')
            argv+=("$font")
        done

        cfg \
            | ${lemonbar} \
                -d \
                -g "$(bar_width)x''${height}x0x1000" \
                "''${argv[@]}" \
            | ${bash} &
        local lemonbar_pid="$!"

        run_trayer &
        local trayer_pid="$!"

        wait "$lemonbar_pid"
        wait "$trayer_pid"
    }

    run
  '';
in {
  systemd.user.services.lemonbar =
    (with config.cfgLib; enableFor users.kotfind)
    (autostartService {
      cmd = lib.getExe lemonbarScript;
    });
}

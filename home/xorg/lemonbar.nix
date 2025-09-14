{
  config,
  lib,
  pkgs,
  ...
}: let
  autostartService = import ./autostart-service.nix {inherit lib;};

  inherit (lib) getExe getExe';
  inherit (config.cfgLib) enableFor matchFor users hosts;

  date = getExe' pkgs.toybox "date";
  echo = getExe' pkgs.toybox "echo";
  top = getExe' pkgs.toybox "top";
  grep = getExe' pkgs.toybox "grep";
  printf = getExe' pkgs.toybox "printf";
  sleep = getExe' pkgs.toybox "sleep";
  free = getExe' pkgs.toybox "free";
  sed = getExe' pkgs.toybox "sed";
  cat = getExe' pkgs.toybox "cat";

  bspc = getExe' pkgs.bspwm "bspc";
  pactl = getExe' pkgs.pulseaudio "pactl";
  xtitle = getExe pkgs.xtitle;
  awk = getExe pkgs.gawk;
  xrandr = getExe pkgs.xorg.xrandr;
  trayer = getExe pkgs.trayer;
  lemonbar = getExe pkgs.lemonbar-xft;
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
      if (matchFor hosts.laptop)
      then ''
        capacity="$(${cat} /sys/class/power_supply/BAT0/capacity)"
        printf "B: %2d%%" "$capacity"
      ''
      else ''
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
  systemd.user.services.lemonbar = enableFor users.kotfind (autostartService {
    cmd = lib.getExe lemonbarScript;
  });
}

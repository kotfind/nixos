#!/usr/bin/env bash

set -euo pipefail

exe="$0"

# -------------------- Colors --------------------

C='\e[0m' # clear
B='\e[1m' # bold
U='\e[4m' # underline
BR='\e[1;31m' # bold red
BG='\e[1;32m' # bold green

# -------------------- Consts --------------------

SHOULD_SOURCE_MSG="
# If you are seeing this message, than you are probably using this
# command incorrectly. You need to ${B}source${C} it's output, instead
# of just running. See for more information:
#   ${B}$exe${C} --help
"

# -------------------- Helpers --------------------

is_disabled() {
    [ -n "${NOTIFY_ON_EXIT_DISABLED+_}" ]
    return
}

# -------------------- Cli --------------------

cli_notify_enable() {
    echo -e "$SHOULD_SOURCE_MSG\nunset NOTIFY_ON_EXIT_DISABLED"
    exit 0
}

cli_notify_disable() {
    echo -e "$SHOULD_SOURCE_MSG\nexport NOTIFY_ON_EXIT_DISABLED=''"
    exit 0
}

cli_notify_status() {
    if is_disabled
    then
        echo -e "${BR}notify-on-exit is disabled${C}"
        exit 1
    else
        echo -e "${BG}notify-on-exit is enabled${C}"
        exit 0
    fi
}

cli_notify() {
    local cmd_exit_code
    cmd_exit_code=$(( $1 ))

    local cmd_text
    cmd_text="${*:2}"

    is_disabled && exit 0

    local this_window_id
    this_window_id=$(( WINDOWID ))

    local active_window_id
    active_window_id=$(( "$(xdotool getactivewindow 2> /dev/null)" )) || active_window_id=0

    (( this_window_id == active_window_id )) && exit 0

    if (( cmd_exit_code == 0 ))
    then
        notify-send \
            -a 'command-executed' \
            'Command executed' \
            "$cmd_text"
    else
        notify-send \
            -a 'command-failed' \
            "Command failed (status: $cmd_exit_code)" \
            "$cmd_text"
    fi

    exit 0
}

# -------------------- Opts & Usage --------------------

usage() {
echo -en "
${B}Usage:${C}
$B$exe$C -h|--help|-s|--status
$B$exe$C -n|--notify <CMD_EXIT_CODE> <CMD_TEXT...>
. <($B$exe$C -e|--enable|-d|--disable)

${B}Description:${C}
This script has two modes: ${U}cli${C} and ${U}notify${C}. To enable ${U}notify${C} mode,
one should run this with ${U}-n${C}/ ${U}--notify${C} flag.

${U}Notify${C} mode should be run by your shell right after an end of any
command's execution. It will send a notification if and only if the script
is running from ${B}not${C} focused window.

${U}Cli${C} mode allows modifying the behavior of ${U}notify${C} mode.

${B}Options:${C}

-h, --help      Print this message.

-d, --disable   Disable notifications in the current shell.
                Output should be ${B}source${C}-ed (see ${B}Usage${C} section).

-e, --enable    Enable notifications in the current shell (if previously disabled).
                Output should be ${B}source${C}-ed (see ${B}Usage${C} section).

-s, --status    Check whatever notifications are disabled or not.

-n, --notify    Run in ${U}notify${C} mode. Conflicts with all other options.
                If specified, two positional arguments should be provided:
                ${U}executed command's return code${C} and ${U}the command itself${C}.

${B}Examples:${C}

Install a POSTEXE hook for ble.sh:

    ${B}blehook${C} POSTEXEC+='/path/to/notify-on-exit.sh --notify -- \$BLE_PIPESTATUS \"\$@\"'

" 2>&1
}

# -------------------- Main --------------------

main() {
    local short_opts
    short_opts="hdesn"
    local long_opts
    long_opts="help,disable,enable,status,notify"

    local parsed_opts
    if ! parsed_opts="$(getopt -n "$0" -o "$short_opts" -l "$long_opts" -- "$@")"
    then
        echo -e "\n${BR}failed to parse command line arguments${C}"
        usage
        exit 1
    fi

    eval set -- "$parsed_opts"

    local is_notify_mode
    is_notify_mode=false

    while true; do
        case "$1" in
            -h|--help)
                usage
                exit 0
                ;;

            -d|--disable)
                cli_notify_disable
                ;;

            -e|--enable)
                cli_notify_enable
                ;;

            -s|--status)
                cli_notify_status
                ;;

            -n|--notify)
                is_notify_mode=true
                shift
                ;;

            --)
                shift
                break
                ;;

            *)
                echo -e "${BR}unreachable${C}" 1>&2
                usage 1
                exit 1
                ;;
        esac
    done

    if [ "$is_notify_mode" != true ]
    then
        echo -e "${BR}providing flags is required${C}"
        usage
        exit 1
    fi

    if (( $# < 2 ))
    then
        echo -e "${BR}notify mode requires at least two arguments ($# provided)${C}" 1>&2
        usage
        exit 1
    fi

    cli_notify "$1" "$2"
}

main "$@"

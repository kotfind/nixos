{ pkgs, ... }:
pkgs.writeShellScriptBin "nolink" /* bash */ ''
    set -euo pipefail

    exec_name="$0"

    usage() {
    cat << END 1>&2
    Usage:
        ''${exec_name} -h
        ''${exec_name} <LINK_FILE>

    Description:
        Turns <LINK_FILE> symlink into normal file by copying it.
    END
    }

    while getopts ":h" arg; do
        case "$arg" in
            "h")
                usage
                exit 0
                ;;

            *)
                usage
                exit 1
                ;;
        esac
    done
    shift $((OPTIND - 1))

    if [ ! -z "''${1+set}" ]; then
        link_file="$1"
    else
        usage
        exit 1
    fi

    # https://stackoverflow.com/a/36180056
    if [ -L "$link_file" ]; then
        if [ ! -e "$link_file" ]; then
            echo "error: symlink '$link_file' points to a non-existant file" 1>&2
        fi
    elif [ -e "$link_file" ]; then
        echo "error: file '$link_file' is not a symlink" 1>&2
    else
        echo "error: file '$link_file' does not exist" 1>&2
    fi

    tmp_file="$(mktemp "$(dirname "$link_file")/tmp-link.XXXXXXXX")"

    cp "$(readlink "$link_file")" "$tmp_file"
    unlink "$link_file"
    mv "$tmp_file" "$link_file"
''

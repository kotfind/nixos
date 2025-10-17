{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe getExe';

  xdotool = getExe pkgs.xdotool;
  pstree = getExe pkgs.pstree;
  awk = getExe pkgs.gawk;
  notify-send = getExe' pkgs.libnotify "notify-send";
in {
  programs.fish.functions = {
    fish_greeting = "";

    fish_command_not_found =
      # fish
      ''
        __fish_default_command_not_found_handler $argv
      '';

    tempcd =
      # fish
      ''
        set dir (mktemp -d /tmp/tempcd.XXXXXXXXXX)
        echo $dir
        cd $dir
      '';

    start =
      # fish
      ''
        $argv[1..-1] &> /dev/null & disown
      '';

    _notify-on-finish_notify =
      # fish
      ''
        set -l focused_window_pid "$(
          ${xdotool} getwindowfocus getwindowpid 2> /dev/null
        )"

        if [ $status -ne 0 ]
          return
        end

        if [ -z "$focused_window_pid" ]
          return
        end

        set -l this_pid $fish_pid
        set -l focused_pids (
          string split (
            ${pstree} -p $focused_window_pid | ${awk} '{ print $2; }'
          )
        )

        if not contains $this_pid $focused_pids
          ${notify-send} \
            -a 'fish-command-executed' \
            'Command executed' \
            $argv[1]
        end
      '';

    notify-on-finish = {
      onEvent = "fish_postexec";
      body =
        # fish
        ''
          if [ (count $argv) != 1 ]
            echo 'failed to parse args' 1>&2
            return 1
          end

          if [ $argv[1] = '--disable' ]; or [ $argv[1] = '-d' ]
            set -g NO_NOTIFY_ON_FINISH
            set -x NO_NOTIFY_ON_FINISH
            return
          end

          if not set -q NO_NOTIFY_ON_FINISH
            _notify-on-finish_notify $argv[1]
          end
        '';
    };
  };

  programs.fish.interactiveShellInit =
    # fish
    ''
      # manually load an --on-event function
      source ~/.config/fish/functions/notify-on-finish.fish

      # complete for `start`
      complete -c start -xa "(__fish_complete_subcommand)"

      # complete for `notify-on-finish`
      complete -c notify-on-finish -f
      complete -c notify-on-finish -s d -l disable -d 'disable on-finish notifications'
    '';
}

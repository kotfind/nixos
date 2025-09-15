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

    notify-on-finish = {
      onEvent = "fish_postexec";
      body =
        # fish
        ''
          set -l focused_window_pid (${xdotool} getwindowfocus getwindowpid)
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
    };
  };

  programs.fish.interactiveShellInit =
    # fish
    ''
      # manually load an --on-event function
      source ~/.config/fish/functions/notify-on-finish.fish
    '';
}

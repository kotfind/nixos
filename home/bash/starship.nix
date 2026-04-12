{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) writeShellScript;
  inherit (lib) getExe concatStrings;

  starshipBin = getExe pkgs.starship;
in {
  programs.starship = {
    enable = true;
    settings = {
      # -------------------- General --------------------

      add_newline = true;
      command_timeout = 200; # ms

      # -------------------- Left --------------------

      format = concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$git_state"
        "\${custom.is_root_symbol}"
      ];

      directory = {
        truncation_length = 2;
        truncation_symbol = "…/";
        truncate_to_repo = false;
        repo_root_style = "underline green";
        style = "green";
      };

      git_branch = {
        format = "[$branch(:$remote_branch)]($style) ";
        style = "purple";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        stashed = "";
        style = "purple";
      };

      git_state = {
        style = "purple";
      };

      custom.is_root_symbol = {
        command = writeShellScript "starship-is-root-symbol" ''
          if [ "$EUID" = "0" ]; then
            printf '\e[31m#\e[0m'
          else
            printf '\e[32m$\e[0m'
          fi
        '';
        unsafe_no_escape = true;
        format = "$output ";
        when = true;
        description = "Shows `#` for root and `$` for normal user";
      };

      # -------------------- Right --------------------

      right_format = concatStrings [
        "([$username](green)@$hostname )"
        "$shlvl"
        "$cmd_duration"
      ];

      username.format = "$user";

      hostname.format = "$hostname";

      shlvl = {
        disabled = false;
        format = "[\\[$shlvl\\]]($style) ";
        style = "blue";
      };

      cmd_duration = {
        format = "[\\[$duration\\]]($style)";
        min_time = 0;
        style = "yellow";
      };
    };
  };

  # works better than `enableBashIntegration`
  programs.starship.enableBashIntegration = false;
  programs.bash.initExtra = ''
    eval "$(${starshipBin} init bash)"
  '';
}

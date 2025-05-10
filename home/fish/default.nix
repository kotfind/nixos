{pkgs, ...}: {
  programs.fish = {
    enable = true;

    functions = let
      prompt = import ./prompt.nix;
      funcs = import ./funcs.nix;
    in
      funcs
      // {
        fish_prompt = prompt.left;
        fish_right_prompt = prompt.right;

        fish_greeting = "";
        fish_command_not_found =
          /*
          fish
          */
          ''
            __fish_default_command_not_found_handler $argv
          '';
      };

    shellAliases = import ./aliases.nix {inherit pkgs;};

    interactiveShellInit =
      /*
      fish
      */
      ''
        # Reset abbreviations
        set -g fish_user_abbreviations

        # Path aliases
        for i in (seq 3 10)
            alias (string repeat -n$i '.')="cd $(string repeat -n (math $i - 1) '../')"
        end

        # Bash-like history substitution !!
        # source: https://fishshell.com/docs/current/faq.html#why-doesn-t-history-substitution-etc-work
        function _last_history_item
          echo $history[1]
        end
        abbr -a !! --position anywhere --function _last_history_item
      '';
  };

  programs.eza.enable = true;

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  home.packages = with pkgs; [
    # for yazi image preview
    ueberzugpp
  ];
}

{...}: {
  programs.fish.interactiveShellInit =
    # fish
    ''
      # reset abbreviations
      set -g fish_user_abbreviations

      # path aliases
      for i in (seq 3 10)
          alias (string repeat -n$i '.')="cd $(string repeat -n (math $i - 1) '../')"
      end

      # bash-like history substitution !!
      # source: https://fishshell.com/docs/current/faq.html#why-doesn-t-history-substitution-etc-work
      function _last_history_item
        echo $history[1]
      end
      abbr -a !! --position anywhere --function _last_history_item
    '';
}

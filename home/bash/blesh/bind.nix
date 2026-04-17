{...}: {
  home.file.".blerc".text = ''
    ble-bind -f 'C-w' 'kill-region-or kill-backward-cword'
    ble-bind -f 'M-e' 'edit-and-execute-command'
    ble-bind -f 'C-RET' 'accept-line'

    ble-bind -f 'up'   'history-search-backward hide-status:action=load:point=end:immediate-accept'
    ble-bind -f 'down' 'history-search-forward  hide-status:action=load:point=end:immediate-accept'
  '';
}

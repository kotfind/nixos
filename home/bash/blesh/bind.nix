{...}: {
  home.file.".blerc".text = ''
    ble-bind -m 'emacs' -f 'C-w' 'kill-region-or kill-backward-cword'

    ble-bind -m 'emacs' -f 'M-e' 'edit-and-execute-command'

    ble-bind -m emacs -f 'C-RET' 'accept-line'
  '';
}

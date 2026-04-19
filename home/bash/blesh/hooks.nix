{...}: {
  home.file.".blerc".text = ''
    blehook POSTEXEC+='notify-on-exit --notify -- $BLE_PIPESTATUS "$@"'
  '';
}

{...}: {
  home.file.".blerc".text = ''
    blehook POSTEXEC+='notify-on-exit hook "$?" "$1"'
  '';
}

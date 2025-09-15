# NOTE: not a module
{pkgs}:
pkgs.writeShellApplication {
  name = "show-volume-notify";

  runtimeInputs = with pkgs; [
    libnotify
    pamixer
  ];

  text = ''
    if [ "$(pamixer --get-mute)" == "true" ]; then
      notify-send \
          -u 'critical' \
          -a 'volume-muted' \
          'Volume [MUTED]'
    else
      notify-send \
          -u 'critical' \
          -a 'volume' \
          -h "int:value:$(pamixer --get-volume)" \
          'Volume'
    fi
  '';
}

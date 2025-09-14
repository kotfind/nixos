# NOTE: not a module
{pkgs}:
pkgs.writeShellApplication {
  name = "show-music-notify";

  runtimeInputs = with pkgs; [
    libnotify
    playerctl
  ];

  text = ''
    paused_msg=""
    if [ "$(playerctl status)" == "Paused" ]; then
      paused_msg=' [PAUSED]'
    fi

    image_path="$(playerctl metadata -f '{{mpris:artUrl}}' | sed 's/file:\/\///')"
    body="$(playerctl metadata -f '{{artist}} —  {{title}}')"

    notify-send \
      -u 'critical' \
      -h "string:image-path:$image_path" \
      "Track$paused_msg" \
      "$body"
  '';
}

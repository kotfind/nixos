# NOTE: not a module
{
  pkgs,
  config,
}: let
  inherit (config.cfgLib) matchFor hosts;
  inherit (pkgs) writeShellApplication;
in
  if (! matchFor hosts.laptop)
  then (throw "brightness script is only available on a laptop")
  else
    (writeShellApplication {
      name = "show-brightness-notify";

      runtimeInputs = with pkgs; [
        libnotify
        light
        toybox
      ];

      text = ''
        brightness="$(printf '%.*f\n' 0 "$(light)")"

        notify-send \
            -u 'critical' \
            -a 'brightness' \
            -h "int:value:$brightness" \
            'Brightness'
      '';
    })

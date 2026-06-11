{
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) readFile;
  inherit (lib) getExe;

  claudeNotify = pkgs.writeShellApplication {
    name = "claude-notify";
    text = readFile ./notify.sh;
    runtimeInputs = with pkgs; [
      xdotool
      libnotify
      xorg.xkbutils
    ];
  };

  claudeNotifyBin = getExe claudeNotify;
in {
  services.dunst.settings.claude-code = {
    appname = "^claude-code$";
    new_icon = "${./icon.svg}";
    min_icon_size = 50;
    max_icon_size = 50;
    timeout = "5s";
  };

  programs.claude-code.settings.hooks = {
    Notification = [
      {
        hooks = [
          {
            type = "command";
            command = ''${claudeNotifyBin} 'Input required' &'';
          }
        ];
      }
    ];
    Stop = [
      {
        hooks = [
          {
            type = "command";
            command = ''${claudeNotifyBin} 'Done' &'';
          }
        ];
      }
    ];
  };
}

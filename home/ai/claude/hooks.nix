{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;
  inherit (builtins) readFile;
  inherit (pkgs.writers) writePython3Bin;

  claudeNotify = writePython3Bin "claude-hooks" {
    libraries = with pkgs.python3Packages; [
      ewmh
      notify2
      pydantic
      systemd-python
      xlib
    ];
  } (readFile ./claude-hooks.py);

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
            command = "${claudeNotifyBin}";
          }
        ];
      }
    ];
    Stop = [
      {
        hooks = [
          {
            type = "command";
            command = "${claudeNotifyBin}";
          }
        ];
      }
    ];
  };
}

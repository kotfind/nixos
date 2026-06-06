{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (builtins) readFile;
  inherit (pkgs) writeShellScriptBin writeShellApplication;
  inherit (lib) getExe;
  inherit (config) sops;

  claudeCodeBin = getExe pkgs.claude-code;

  claudeCodeWithToken = writeShellScriptBin "claude" ''
    export ANTHROPIC_AUTH_TOKEN="$(cat ${sops.secrets.deepseekKey.path} | xargs)"
    exec ${claudeCodeBin} "$@"
  '';

  claudeNotify = writeShellApplication {
    name = "claude-notify";
    text = readFile ./claude-notify.sh;
    runtimeInputs = with pkgs; [
      xdotool
      libnotify
    ];
  };

  claudeNotifyBin = getExe claudeNotify;
in {
  services.dunst.settings.claude-code = {
    appname = "^claude-code$";
    new_icon = "${./claude.svg}";
    min_icon_size = 50;
    max_icon_size = 50;
    timeout = "5s";
  };

  programs.claude-code = {
    enable = true;
    package = claudeCodeWithToken;
    settings = {
      env = {
        ANTHROPIC_BASE_URL = "https://api.deepseek.com/anthropic";
        ANTHROPIC_MODEL = "deepseek-v4-pro[1m]";
        ANTHROPIC_DEFAULT_OPUS_MODEL = "deepseek-v4-pro[1m]";
        ANTHROPIC_DEFAULT_SONNET_MODEL = "deepseek-v4-pro[1m]";
        ANTHROPIC_DEFAULT_HAIKU_MODEL = "deepseek-v4-flash[1m]";
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
        CLAUDE_CODE_EFFORT_LEVEL = "max";
      };
      alwaysThinkingEnabled = false;
      hooks = {
        Notification = [
          {
            hooks = [
              {
                type = "command";
                command = ''${claudeNotifyBin} 'Input required' '';
              }
            ];
          }
        ];
        Stop = [
          {
            hooks = [
              {
                type = "command";
                command = ''${claudeNotifyBin} 'Done' '';
              }
            ];
          }
        ];
      };
    };
  };
}

{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (pkgs) writeShellScriptBin;
  inherit (lib) getExe;
  inherit (config) sops;

  claudeCodeBin = getExe pkgs.claude-code;

  notifySend = getExe pkgs.libnotify;
  xdotool = getExe pkgs.xdotool;

  claudeCodeWithToken = writeShellScriptBin "claude" ''
    export ANTHROPIC_AUTH_TOKEN="$(cat ${sops.secrets.deepseekKey.path} | xargs)"
    exec ${claudeCodeBin} "$@"
  '';
in {
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
                command = ''[ "$WINDOWID" != "$(${xdotool} getactivewindow)" ] && ${notifySend} "Claude Code" "Input required" || true'';
              }
            ];
          }
        ];
        Stop = [
          {
            hooks = [
              {
                type = "command";
                command = ''[ "$WINDOWID" != "$(${xdotool} getactivewindow)" ] && ${notifySend} "Claude Code" "Done" || true'';
              }
            ];
          }
        ];
      };
    };
  };
}

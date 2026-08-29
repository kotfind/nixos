{...}: {
  programs.claude-code.settings = {
    alwaysThinkingEnabled = false;

    env.CLAUDE_CODE_DISABLE_MOUSE = "1";
  };
}

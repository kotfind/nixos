{...}: {
  programs.claude-code.settings = {
    alwaysThinkingEnabled = false;

    env.CLAUDE_CODE_DISABLE_MOUSE = "1";
    env.CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
    env.CLAUDE_CODE_EFFORT_LEVEL = "low";
  };
}

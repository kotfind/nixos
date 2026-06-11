{...}: {
  programs.claude-code = {
    enable = true;
    rulesDir = ./rules;
  };
}

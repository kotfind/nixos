{config, ...}: let
  homeDir = config.home.homeDirectory;
in {
  programs.claude-code.settings.permissions = {
    allow = [
      "Read"
      "Bash(git log:*)"
      "Bash(git diff:*)"
      "Bash(git status:*)"
      "Bash(git show:*)"
      "Bash(eza:*)"
      "Bash(fd:*)"
      "Bash(rg:*)"
      "Bash(nix build:*)"
      "Bash(nix eval:*)"
      "Bash(nix flake check:*)"
      "Bash(nix search:*)"
      "Bash(nix-locate:*)"
      "Bash(nix-instantiate:*)"
      "WebSearch"
      "WebFetch"
    ];
    additionalDirectories = [
      "/etc/nixos"
      "${homeDir}/nixos"
      "${homeDir}/.cargo/registry/cache"
      "${homeDir}/.cargo/registry/index"
    ];
  };
}

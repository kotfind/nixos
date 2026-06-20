# NixOS & Flakes

- This system runs NixOS with Nix flakes. All configuration is declarative.
- To install an app permanently, add it to a devShell (not `nix profile` or `nix-env`)
- To try a command temporarily, use `nix run` or `nix shell`
- devShells are loaded via `.envrc` files with `direnv`. `direnv allow` does not work from Claude Code.
  - If a new flake needs activation: run `nix flake check`, then tell the user to `direnv allow` themselves.

# Preinstalled Tools

These are always available — you can use those:

| Tool | Use instead of | Notes |
|------|---------------|-------|
| `eza` | `ls`, `tree` | Modern ls replacement with tree support (`eza -T`) |
| `fd` | `find` | Faster, friendlier file search |
| `rg` (`ripgrep`) | `grep` | Recursive search by default, respects `.gitignore` |
| `jq` | — | JSON processor |
| `xh` | `curl` (for APIs) | HTTPie-like, nicer JSON output |
| `direnv` | — | Auto-loads `.envrc` on directory entry |
| `htop` | `top` | Interactive process viewer |

# Sudo

- Always use `sudo -A` when running commands that need root. The `-A` flag makes sudo read the password from `$SUDO_ASKPASS` (a rofi prompt), which works without a TTY.

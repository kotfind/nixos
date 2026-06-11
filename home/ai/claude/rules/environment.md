# NixOS & Flakes

- This system runs NixOS with Nix flakes — all configuration is declarative
- To install an app permanently, add it to a devShell (not `nix profile` or `nix-env`)
- To try a command temporarily, use `nix run` or `nix shell`
- devShells are loaded via `.envrc` files with `direnv` — run `direnv allow` to activate

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

---
paths:
  - "**/*.nix"
---

# NixOS Configuration Conventions

- `default.nix` files must **only** contain `imports = [...]` — no other options or logic
- Put unclassified / general configuration in `general.nix`
- Keep `imports` list items sorted alphabetically
- One concern per file; extract when a file grows beyond its primary purpose

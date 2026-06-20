---
name: learn
description: >
  Explore the current project to understand its structure,
  build system, and conventions. Use when starting a new
  session or catching up after the user made changes.
---

# Learning a Project

When asked to learn a project, do a thorough exploration:

- Run `eza -T` at the project root to see the directory layout
- Read the top-level config files: `flake.nix`, `Cargo.toml`, `package.json`, `Makefile`, etc. -- anything that describes the build system and dependencies
- Read any project-level documentation: `README.md`, `CONTRIBUTING.md`, `CLAUDE.md`
- Identify the tech stack, build commands, test commands, and formatters in use
- Check `git log --oneline -20` for recent activity
- Check `git status` to understand what's changed vs committed

When re-learning (the user made changes and asks you to catch up):

- Focus on what changed: `eza -T` if the file tree changed, `git diff` or `git status` for uncommitted changes
- Re-read config files that may have been updated
- Don't re-read files that clearly haven't changed
- Summarize what you found and what's different from before

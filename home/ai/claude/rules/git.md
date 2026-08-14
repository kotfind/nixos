# Git Conventions

- Remove `Co-Authored-By` lines from commit messages -- don't include them
- Keep commit messages simple and single-line when possible
- Only describe the general idea of the change, not implementation details

## Before Committing

- Always run `git status` before `git commit` and read its output
- Confirm that only the intended changes are staged -- stop and investigate if anything unexpected is there
- If `git status` shows untracked files that should not be committed (build artifacts, generated files, local-only files), add entries for them to `.gitignore`

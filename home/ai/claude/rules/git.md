# Git Conventions

- Never pass `-C` to `git` unless operating on a different directory
- Remove `Co-Authored-By` lines from commit messages -- don't include them
- Keep commit messages simple and single-line when possible
- Only describe the general idea of the change, not implementation details

## Before Committing

- Run `git status` right before `git commit` and read its output
- Re-run it after any operation that changes the working tree or index (`git add`, `git rm`, file edits, formatters) -- an earlier check does not count
- Confirm that only the intended changes are staged -- stop and investigate if anything unexpected is there
- If `git status` shows untracked files that should not be committed (build artifacts, generated files, local-only files), add entries for them to `.gitignore`

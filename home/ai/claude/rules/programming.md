# Programming Style

## Imports

- Prefer importing specific items over fully-qualified paths, unless it hurts readability
  - Good: `use std::collections::HashMap;` then `HashMap::new()`
  - Acceptable: `use std::collections` then `collections::HashMap::new()` when names would collide
- When the source of an import isn't obvious from the name, keep it qualified

## Unicode

- **Never** use unicode characters in code comments, error messages, or structured text. This includes:
  - Em dashes and en dashes. Use `--` or `---` instead.
  - Curly/smart quotes. Use straight quotes `"` and `'` only.
  - Ellipsis. Use `...` instead.
  - Any other special unicode symbols.
- Stick to plain ASCII for all code and adjacent prose.
- The only exception is when explicitly asked by the user, or when the character is technically required (e.g. inside a string literal).

## Formatting

- Run the formatter matching the file type before committing. Do not ask for permission.
- Formatter by file type:
  - `.rs`: `rustfmt`
  - `.nix`: `alejandra`
  - `.lua`: `stylua`
  - `.py`: `ruff`
  - `.typ`: `typstyle`
  - `.toml`: `tombi`
  - `.c`, `.cpp`: `clang-format`
  - `.elm`: `topiary`
  - `.jinja`: `djlint`

## Shell Commands

- When a command chains many operations with `&&`, `||`, `|`, or `;`, split it across multiple lines with `\` for readability.
- Short commands with simple logic don't need splitting. E.g.:
  - `cmd1 && cmd2 && cmd3` -- split it
  - `do smth | tail -n 5` -- fine on one line

## Dependencies

- Prefer the latest stable version of packages and libraries.
- Don't use deprecated or unmaintained packages. Check for alternatives.

## Builds

- Build and run in debug mode by default. Only use `--release` (or equivalent) when the user asks for it or when performance is required.

## File Size

- Prefer small, focused files to large monolithic ones
- Split a file when it covers more than one distinct concern

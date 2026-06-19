# Programming Style

## Imports

- Prefer importing specific items over fully-qualified paths, unless it hurts readability
  - Good: `use std::collections::HashMap;` then `HashMap::new()`
  - Acceptable: `use std::collections` then `collections::HashMap::new()` when names would collide
- When the source of an import isn't obvious from the name, keep it qualified

## Unicode

- **Never** use unicode characters, like long dashes (`—`), curly quotes (`"" ''`), or special symbols in code comments, error messages, or structured text, unless absolutely necessary or explicitly asked.
- Stick to plain ASCII for all code and adjacent prose.

## File Size

- Prefer small, focused files to large monolithic ones
- Split a file when it covers more than one distinct concern

---
paths:
  - "**/*.rs"
---

# Rust Module Conventions

- `mod.rs` must **only** contain `pub mod` / `mod` declarations -- no functions, types, or impls
- Re-export key types from parent modules so callers can use short paths. E.g. `ollama::embed` instead of `ollama::embed::embed`.
- Make submodules private and `pub use` their public items upward.
- Single-file (`module.rs`) and directory (`module/mod.rs`) modules can coexist in the same project
- Don't mix both styles for the *same* module -- never have `module.rs` alongside `module/`

# Spacing

- Separate struct fields and enum variants with a blank line between each definition.

# Imports

- Merge same-crate use imports into one expression.
- Import specific items rather than using fully-qualified paths, unless it hurts readability.

# Error Handling

- Create domain-specific error enums with `thiserror`.

# Context / State

- Wrap immutable runtime state in `Arc<...>` cheap-to-clone structs.
- Use `OnceLock` for one-time initialization guards.

# Doc Links

- Use `[Type]` in doc comments for intra-doc links (resolved by path).

# Cargo

- Keep all dependency versions in the workspace `Cargo.toml` under `[workspace.dependencies]`.
- Use `cargo autoinherit` to migrate deps to the workspace.
- Use `cargo clippy` instead of `cargo check` to verify code compiles. Clippy catches more issues.
- Use `cargo machete` to find and remove unused dependencies.

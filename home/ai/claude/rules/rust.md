---
paths:
  - "**/*.rs"
---

# Rust Module Conventions

- `mod.rs` must **only** contain `pub mod` / `mod` declarations — no functions, types, or impls
- Single-file (`module.rs`) and directory (`module/mod.rs`) modules can coexist in the same project
- Don't mix both styles for the *same* module — never have `module.rs` alongside `module/`

---
name: mkflake
description: Create or modify flake.nix files for project devShells or packages.
---

# flake.nix Conventions

## Structure

- Use `flake-utils.lib.eachDefaultSystem` -- always
- Inputs go at the top: `nixpkgs`, `flake-utils`, then language-specific ones
- When an input's flake has a `nixpkgs` input, follow it: `inputs.thisInput.follows = "nixpkgs"`
- nixpkgs url is `"nixpkgs"` (resolves to nixos-unstable via registry)
- In `outputs`, accept `{nixpkgs, flake-utils, extraInputs, ...}` -- the `...` absorbs `self` and any inputs you don't need to reference

## Let block

- `inherit (pkgs) mkShell` -- first line after importing nixpkgs
- Import language-specific toolchains next (fenix for Rust, python3.withPackages for Python, etc.)
- Define `shell = mkShell { ... }` last

## Shell definitions

- `name = "project-name-shell"` -- kebab-case with `-shell` suffix
- Group `buildInputs` items into `++`-separated blocks by the `with` scope they need:
  ```nix
  buildInputs =
    [rustToolchain]
    ++ (with pkgs; [
      cargo-machete

      openssl
      pkg-config
    ]);
  ```
- When items need different `with` scopes, add separate `++` blocks:
  ```nix
  buildInputs =
    [rustToolchain]
    ++ (with pkgs; [
      cargo-machete
    ])
    ++ (with pkgs.elmPackages; [
      elm
      elm-language-server
    ]);
  ```
- Use blank lines for logical subgroups within the same `with` block

## Rust toolchains

- Use fenix, never rust-overlay
- Use `stable.withComponents [...]`
- Always include: `rustc`, `cargo`, `rustfmt`, `clippy`, `rust-src`, `rust-analyzer`

## Naming

- `camelCase` for variable bindings (e.g. `rustToolchain`, `runtimeLibs`)
- `kebab-case` for derivations and shell names (e.g. `project-name-shell`, `my-package`)
- When adding a prefix to an existing name, keep the original convention: `some-package` -> `some-package-src`, `someVariable` -> `someVariableOrig`

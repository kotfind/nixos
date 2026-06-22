---
name: mkflake
description: Create or modify flake.nix files for project devShells or packages.
---

# flake.nix Conventions

## Structure

```nix
{
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, flake-utils, fenix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        inherit (pkgs) mkShell;
        ...
      in
      {
        devShells.default = mkShell {
          name = "project-name-shell";
          buildInputs = with pkgs; [ ... ];
        };
      });
}
```

- Use `flake-utils.lib.eachDefaultSystem` -- always
- Inputs go at the top: `nixpkgs`, `flake-utils`, then language-specific ones
- When an input's flake has a `nixpkgs` input, follow it: `inputs.thisInput.follows = "nixpkgs"`
- nixpkgs url is `"nixpkgs"` (resolves to nixos-unstable via registry)
- In `outputs`, accept `{ nixpkgs, flake-utils, extraInputs, ... }` -- the `...` absorbs `self` and any inputs you don't need to reference
- `eachDefaultSystem (system:` opens on the same line, `let` indented underneath, `in` at the same indent, then `{ devShells.default = shell; }` at the next indent

## Let block

- `inherit (pkgs) mkShell` -- first line after importing nixpkgs
- Import language-specific toolchains next (fenix for Rust, python3.withPackages for Python, etc.)
- Define `shell = mkShell { ... }` last

## Shell definitions

- Only define `devShells.default` -- don't add named shells unless you actually need more than one
- `name = "project-name-shell"` -- kebab-case with `-shell` suffix
- Group `buildInputs` items into `++`-separated blocks by the `with` scope they need:
  ```nix
  buildInputs =
    [ rustToolchain ]
    ++ (with pkgs; [
      cargo-machete

      openssl
      pkg-config
    ]);
  ```
- When items need different `with` scopes, add separate `++` blocks:
  ```nix
  buildInputs =
    [ rustToolchain ]
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
- Always include: `rustc`, `cargo`, `rustfmt`, `clippy`, `rust-src`, `rust-analyzer`
- Use `combine`:
  ```nix
  rustToolchain = with fenix.packages.${system};
    combine (with stable; [
      rustc
      cargo
      rustfmt
      clippy
      rust-src
      rust-analyzer
    ]);
  ```
- When you need cross-compilation targets, merge with `++`:
  ```nix
  rustToolchain = with fenix.packages.${system};
    combine (
      (with stable; [ ... ])
      ++ (map (t: targets.${t}.stable.rust-std) [
        "armv7-unknown-linux-gnueabihf"
      ])
    );
  ```

## Naming

- `camelCase` for variable bindings (e.g. `rustToolchain`, `runtimeLibs`)
- `kebab-case` for derivations and shell names (e.g. `project-name-shell`, `my-package`)
- When adding a prefix to an existing name, keep the original convention: `some-package` -> `some-package-src`, `someVariable` -> `someVariableOrig`

## Envrc

- After creating `flake.nix`, check if `.envrc` exists. If not, create one with `use flake`.

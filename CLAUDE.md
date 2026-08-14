# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal NixOS + Home Manager configuration as a single flake, shared by two x86_64-linux hosts (`pc`, `laptop`). Config is split between system-level modules (`nixos/`) and per-user Home Manager modules (`home/`).

## Commands

- Rebuild the system: `sudo nixos-rebuild switch --flake .#default`
- Validate the flake: `nix flake check`
- Format Nix files: `alejandra .`
- Decrypt a secret: `sops -d <file>`
- Encrypt a new secret: write the plaintext file, then `sops -e -i <file>`. `.sops.yaml` rules match `*.enc.*` files and `secrets/*.yaml|yml`; the file name must match a rule or sops won't encrypt it.
- Every sops decryption (`sops -d ...`) requires manual user confirmation -- always ask before running it.

The flake only sees git-tracked files: `git add` new or renamed files before rebuilding, or Nix won't find them.

## Architecture

Entry point: `flake.nix` -> `default.nix` builds `nixosSystem` from modules `./nixos` (system config), `./profiles.nix` (definitions), and `./home` (wired via Home Manager). `default.nix` also whitelists unfree packages with `unfreePkgs` -- add new unfree packages there.

**cfgLib** (`cfgLib/`, `profiles.nix`) is the central abstraction for multi-host/multi-user config:

- `profiles.nix` declares `cfgLib.usersDef` (users + per-user data like email) and `cfgLib.hostsDef` (hosts + their users + data like hostname).
- `cfgLib/` generates typed objects `cfgLib.users`, `cfgLib.hosts`, `cfgLib.host`, `cfgLib.user`, plus `cfgLib.userOnHost` objects nested in `cfgLib.host.users`.
- `cfgLib.enableFor <user|host|userOnHost|list> value` gates any config to matching users/hosts. This is the standard way to scope config: use it instead of hardcoding hostnames or usernames.
- `current-host.nix` selects the host (`hosts: hosts.pc`). It is machine-specific and kept out of git with `--skip-worktree`, as is `nixos/hardware-configuration.nix` (generated per machine, gitignored).

`home/` is imported once per user in `default.nix` (one Home Manager instance per user in `cfgLib.host.users`), with `sops-nix` shared modules and the same `cfgLib` available. So most user-scoped config lives under `home/` and is gated with `enableFor`.

Secrets use sops-nix with a single age key. Key file paths are set in `nixos/secrets/default.nix` and `home/secrets/default.nix`.

## Conventions

- `default.nix` files contain only `imports = [...]`, sorted alphabetically -- no options or logic.
- Unclassified or general config goes in `general.nix` within the module's directory.
- One concern per file; extract when a file grows beyond its primary purpose.
- Format all `.nix` files with `alejandra` before committing.

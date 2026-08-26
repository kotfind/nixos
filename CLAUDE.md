# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal NixOS + Home Manager configuration as a single flake, shared by two x86_64-linux hosts (`pc`, `laptop`). Config is split between system-level modules (`nixos/`) and per-user Home Manager modules (`home/`).

## Commands

- Rebuild the system: `sudo nixos-rebuild switch --flake .#pc` (on laptop: `.#laptop`)
- Validate the flake: `nix flake check`
- Format Nix files: `alejandra .`
- Decrypt a secret: `sops -d <file>`
- Encrypt a new secret: write the plaintext file, then `sops -e -i <file>`. `.sops.yaml` rules match `*.enc.*` files and `secrets/*.yaml|yml`; the file name must match a rule or sops won't encrypt it.
- Every sops decryption (`sops -d ...`) requires manual user confirmation -- always ask before running it.

The flake only sees git-tracked files: `git add` new or renamed files before rebuilding, or Nix won't find them.

## Architecture

Entry point: `flake.nix` -> `default.nix` builds one `nixosConfiguration` per host via `hostlib.lib.eachHostSystem` from modules `./nixos` (system config), `./profiles.nix` (definitions), and `./home` (wired via Home Manager). `default.nix` also whitelists unfree packages with `unfreePkgs` -- add new unfree packages there.

**hostlib** (flake input `github:kotfind/hostlib`, options under `config.hostlib`) is the central abstraction for multi-host/multi-user config:

- `profiles.nix` declares `hostlib.users` (users + per-user data like email) and `hostlib.hosts` (hosts + `userNames` + data like hostname). Extra attrs on users/hosts are freeform.
- hostlib generates `hostlib.users.<name>`, `hostlib.hosts.<name>` and resolves `hostlib._curHost` / `hostlib._curUser` from the selected configuration.
- `hostlib.mkFor <user|host|userOnHost> value` gates any config to matching users/hosts (`hostlib.trueFor` returns just the bool; `hostlib.join user host` builds a userOnHost). This is the standard way to scope config: use it instead of hardcoding hostnames or usernames.
- `nixos/hardware-configuration.nix` is generated per machine, gitignored and kept out of git with `--skip-worktree`.

`home/` is imported once per user by hostlib (one Home Manager instance per user in the host's `userNames`), with `sops-nix` modules and the same `hostlib` available. So most user-scoped config lives under `home/` and is gated with `mkFor`.

Secrets use sops-nix with a single age key. Key file paths are set in `nixos/secrets/default.nix` and `home/secrets/default.nix`.

## Conventions

- `default.nix` files contain only `imports = [...]`, sorted alphabetically -- no options or logic.
- Unclassified or general config goes in `general.nix` within the module's directory.
- One concern per file; extract when a file grows beyond its primary purpose.
- Format all `.nix` files with `alejandra` before committing.

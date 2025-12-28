# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS flake-based configuration repository managing multiple hosts (desktop/laptop and server machines). The configuration uses a modular architecture with shared modules and host-specific configurations.

## Build & Development Commands

### Primary Commands (via Task)
```bash
task build    # Build NixOS configuration for current host
task switch   # Apply configuration (requires sudo)
task boot     # Set configuration for next boot
task lint     # Format all .nix files with nixfmt
task update   # Update flake.lock dependencies
```

### Direct nixos-rebuild (fallback/bootstrap)
```bash
nixos-rebuild build --flake .#<hostname>   # Build specific host
nixos-rebuild switch --flake .#<hostname>  # Switch specific host
nixos-rebuild test --flake .#<hostname>    # Test without switching
```

### Available Hosts
- `garuda` - Framework 13 AMD laptop (desktop + devenv + gaming)
- `carbuncle` - Desktop system
- `bahamut` - Desktop system
- `esbcn1-nix-cache1` - Nix cache server
- `esbcn1-nas1` - NAS server (ZFS, Samba, NFS)
- `esbcn1-media1` - Media server

## Architecture & Module System

### Flake Structure
- `flake.nix` - Single source of truth defining all `nixosConfigurations`
- All hosts use `specialArgs = { inherit inputs; }` for consistent input access
- agenix is included in all hosts for secret management

### Module Hierarchy

The repository follows a three-tier module organization:

1. **Core Modules** (`modules/core/`)
   - `global/` - Base configuration applied to ALL systems
     - Imported via `modules/core/global/default.nix`
     - Contains: system.nix, boot.nix, network.nix, ssh.nix, users.nix, tools.nix, shell.nix, monitoring.nix, security.nix
   - `desktop/` - Desktop/laptop-specific configuration
     - Auto-imports `global/` (desktop extends global)
     - Imported via `modules/core/desktop/default.nix`
     - Contains: plymouth.nix, gnome.nix, audio.nix, printing.nix, locales.nix, fingerprint.nix, tools.nix
     - Uses NetworkManager for networking
   - `server/` - Server-specific configuration
     - Auto-imports `global/` (server extends global)
     - Uses systemd-networkd instead of NetworkManager

2. **Domain Modules** (`modules/`)
   - `devenv/` - Development environment configuration
   - `gaming/` - Gaming-related configuration (Steam, etc.)

3. **Host Configurations** (`hosts/<hostname>/`)
   - Each host has `configuration.nix` and `hardware.nix`
   - Hosts import appropriate modules (desktop or server + optional domain modules)
   - Host-specific settings only in these files

### Important Module Patterns

- Desktop module automatically includes global module
- Server module automatically includes global module
- Hosts should import either `desktop/default.nix` OR `server/default.nix`, not both
- Example desktop host imports:
  ```nix
  imports = [
    ./hardware.nix
    ../../modules/core/desktop/default.nix  # includes global automatically
    ../../modules/devenv/default.nix
    ../../modules/gaming/default.nix
  ];
  ```
- Example server host imports:
  ```nix
  imports = [
    ./hardware.nix
    ../../modules/core/server/default.nix  # includes global automatically
  ];
  ```

### Secret Management

- Secrets managed via agenix (imported in all hosts)
- SSH keys defined in `secrets/secrets.nix`
- Never commit plaintext secrets - reference external key sources

## Code Style

- Run `nixfmt` before committing (enforced via `task lint`)
- Two-space indentation, tidy attribute alignment
- Lowercase names with hyphens (e.g., `esbcn1-nas1`, `modules/core/server/`)
- Group imports at top of modules
- Use `let` bindings for complex expressions instead of inline lambdas

## Testing & Validation

- Minimum requirement: `task build` succeeds for affected hosts
- For stateful changes: use `nixos-rebuild test --flake .#<host>` to stage without switching
- No automated test coverage - document manual validation in commits/PRs
- When modifying shared modules, build-test multiple hosts to verify no regressions

## Commit Guidelines

- Short, imperative subject lines (e.g., "add rootless docker", "firewall")
- 72-character soft wrap
- Squash WIP commits before review
- Isolate unrelated refactors into separate commits
- Run `task update` in dedicated commits when updating dependencies

## Special Configuration Notes

- ZFS hosts require `networking.hostId` set
- Desktop hosts using LUKS encryption configure it in `boot.initrd.luks.devices`
- Server networking uses systemd-networkd, desktop uses NetworkManager
- Hardware-specific modules (e.g., Framework laptop) imported in flake.nix via nixos-hardware

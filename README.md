# NixOS Configuration

Personal, reproducible NixOS configuration using **Nix Flakes** and **Home Manager**.

Currently deployed on **NixOS-WSL**, with the goal of sharing most user and system configuration with future native NixOS machines.

## Architecture

```text
.
├── flake.nix
├── flake.lock
├── hosts/
│   └── wsl/
│       └── default.nix
├── modules/
│   └── nixos/
│       ├── common.nix
│       ├── nix-settings.nix
│       ├── security.nix
│       ├── networking.nix
│       └── docker.nix
├── home/
│   ├── common.nix
│   ├── programs/
│   └── dotfiles/
│       └── nvim/
└── docs/
```

## Technology

- NixOS 26.05
- Nix Flakes with a committed `flake.lock`
- Home Manager integrated into NixOS
- Fish and Tide
- Neovim and LazyVim
- Git, SSH and GnuPG
- age and SOPS
- Docker Engine rootless and Docker Compose
- Python / uv, Rust, Go and Nix development tools
- DuckDB, YARA, networking and forensic utilities

## Configuration responsibilities

| Path | Purpose |
|---|---|
| `hosts/wsl/` | WSL-specific configuration |
| `modules/nixos/` | Reusable NixOS system configuration |
| `home/common.nix` | Shared Home Manager configuration |
| `home/programs/` | User applications and CLI tools |
| `home/dotfiles/` | Application configuration files |

## Apply configuration

From NixOS-WSL, using Fish:

```fish
cd ~/nixos-config

git add -A
nix flake check --no-build
and nix build --no-link .#nixosConfigurations.wsl.config.system.build.toplevel
and sudo nixos-rebuild dry-activate --flake .#wsl
```

Review the build and activation results before applying:

```fish
sudo nixos-rebuild switch --flake .#wsl
```

**Important:** only stage trusted configuration files. Never add private keys, tokens, decrypted secrets or investigation data.

## Updates

Review changes to `flake.lock` before rebuilding.

```fish
nix flake update
git diff -- flake.lock
```

Then run the validation and activation commands above.

## Rollback

To switch to a previous system generation:

```fish
sudo nixos-rebuild switch --rollback
```

A rollback does not restore external data, private keys or Docker volumes.

## Security model

- Nix builds use sandboxing.
- Binary cache signatures are required.
- Only root is a trusted Nix daemon user.
- NixOS firewall is enabled.
- OpenSSH server is disabled.
- Docker runs rootless.
- SSH, GPG and age private keys remain outside Git and the Nix store.

WSL relies on the Windows host and does not provide an independent security boundary suitable for malware detonation.

## Secrets and backups

Sensitive identities are stored outside the repository.

Encrypted Restic backups to S3 are **planned but not yet operational**. Until then, rebuilding the NixOS configuration does not guarantee recovery of local secrets or application data.

## Future work

- S3-backed encrypted backups and restoration testing
- Documented installation from a fresh NixOS-WSL distribution
- Migration to a native NixOS laptop
- Hardware-specific host configuration


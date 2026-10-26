# NixOS-WSL development environment

Declarative development setup for **NixOS 26.05 on WSL2**, managed with Nix Flakes and Home Manager.

> **Scope:** This repository currently defines **one NixOS-WSL host** (`wsl`) for the Linux user `nixos`. It is **not** a generic NixOS desktop installer. A second Windows PC running NixOS-WSL can use the same configuration; native NixOS hardware needs a separate host configuration.

## What's included

| Area | Tools / configuration |
| --- | --- |
| Shell | Fish, Tide (two-line prompt), fzf, zoxide, eza |
| Terminal | tmux (Tokyo Night, `Ctrl+Space` prefix), btop, Freshfetch, Yazi |
| Git | Git, Delta, lazygit, rebase-on-pull |
| Editor | Neovim + LazyVim, Lua configuration under `home/dotfiles/nvim/` |
| Python | Python, uv, Ruff, basedpyright |
| Rust | rustc, Cargo, rust-analyzer, Clippy, rustfmt |
| Go | Go, gopls, goimports, gofumpt |
| Nix | nixd, nixfmt |
| Per-project environments | direnv + nix-direnv, Nix devShells |

## Repository layout

```text
.
├── flake.nix                 # NixOS configuration: nixosConfigurations.wsl
├── flake.lock                # Pinned Nix dependencies
├── hosts/wsl/default.nix    # WSL-only settings and clipboard integration
└── home/
    ├── common.nix           # Home Manager user and module imports
    ├── programs/            # Fish, Git, tmux, editors, languages, tools
    └── dotfiles/
        ├── nvim/            # LazyVim Lua, lazy-lock.json, lazyvim.json
        └── tmux/            # Tokyo Night tmux theme
```

## Install on another Windows PC (same `nixos` user)

These instructions assume a fresh NixOS-WSL distribution, not Ubuntu WSL or a native NixOS installation.

### 1. Install NixOS-WSL

On Windows, install or update WSL2, then download a **NixOS-WSL 26.05** `.wsl` image from the [NixOS-WSL releases](https://github.com/nix-community/NixOS-WSL/releases). Follow the [official installation guide](https://nix-community.github.io/NixOS-WSL/install.html).

Recent WSL versions support installing the downloaded image via PowerShell:

```powershell
wsl --install --no-distribution
# From the directory containing the downloaded image:
wsl --install --from-file .\nixos.wsl
wsl -d NixOS
```

The distribution name can differ if you specified another name during installation. Do not install over an existing distribution without backing it up.

### 2. First setup inside NixOS-WSL

Log in as the `nixos` user (the default in the official image) and set its password:

```sh
passwd
```

On a fresh image, the upstream installation guide may also require a one-time channel update for `nixos-rebuild`:

```sh
sudo nix-channel --update
```

Ensure Git and the `nix` CLI are available in the base image. If Git is missing, it can be run temporarily using `nix shell nixpkgs#git` once flakes are enabled.

### 3. Clone into the expected directory

**This exact location is important:** the Neovim Home Manager module uses an out-of-store symlink to `/home/nixos/nixos-config/home/dotfiles/nvim`.

```sh
cd /home/nixos
git clone <YOUR_REPOSITORY_URL> nixos-config
cd nixos-config
```

Replace `<YOUR_REPOSITORY_URL>` with your repository's actual HTTPS or SSH URL. For a private repository, arrange authentication outside the Nix configuration.

### 4. Validate and activate

```sh
nix --extra-experimental-features 'nix-command flakes' flake check --no-build
nix --extra-experimental-features 'nix-command flakes' build --no-link .#nixosConfigurations.wsl.config.system.build.toplevel
sudo nixos-rebuild dry-activate --flake .#wsl
sudo nixos-rebuild switch --flake .#wsl
```

The last command changes the active generation. If Home Manager reports a collision involving an existing dotfile, **inspect and back up that file first** rather than forcing an overwrite.

Restart the WSL terminal or open a new Fish session to pick up the interactive-shell integrations.

### 5. Smoke tests

```fish
for cmd in git fish nvim tmux yazi lazygit rg fd gcc fzf zoxide eza btop freshfetch direnv uv ruff basedpyright rustc cargo rust-analyzer go gopls goimports gofumpt nixd nixfmt
    command -v $cmd; or echo "MISSING: $cmd"
end

readlink -f ~/.config/nvim
nvim
```

The Neovim link should ultimately resolve to `/home/nixos/nixos-config/home/dotfiles/nvim`. On first launch, lazy.nvim may download its plugins and other assets (network access required). Run `:Lazy restore` to align installed plugin revisions with `lazy-lock.json`, and review `:checkhealth`. The Lua bootstrap pins lazy.nvim itself to commit `85c7ff3711b730b4030d03144f6db6375044ae82` for new installs.

Check tmux shortcuts and the Windows clipboard integration only if WSL interoperability provides `clip.exe`.

## Reuse this configuration as someone else

**Do not run the existing flake unchanged if your Linux username is not `nixos`.** The repository currently contains deliberate user-specific assumptions. Fork or copy the repository, and review these locations **before the first activation**:

1. `hosts/wsl/default.nix`: change `wsl.defaultUser`, `users.users.nixos.shell`, and the Home Manager user key used for WSL-specific tmux configuration. Ensure that Linux user exists in the target NixOS-WSL installation.
2. `home/common.nix`: change `home.username` and `home.homeDirectory`.
3. `flake.nix`: inspect any references to `home-manager.users.nixos` or other fixed user names.
4. `home/programs/neovim.nix`: change the symlink target if you use a different username or clone directory. The current setup assumes `~/nixos-config`.
5. `home/programs/git.nix`: **replace the configured Git author name and email** with your own.
6. `hosts/wsl/default.nix`: the tmux copy binding uses Windows `clip.exe`; keep it only if your environment supports WSL interoperability.
7. `home/dotfiles/`: inspect application-specific preferences and shortcuts; some rely on terminal features.

Search the entire repository for assumptions before applying your fork:

```sh
git grep -n -E 'nixos|/home/|nixos-config|clip\.exe|Ston14|@' -- '*.nix' '*.lua' '*.conf' 'flake.nix'
```

The username change is a **manual adaptation**, not a supported automatic installer workflow. For another **native Linux/NixOS PC**, a separate hardware/host configuration would be required; `hosts/wsl/default.nix` must not be treated as a desktop configuration.

## Daily workflow

After changing Nix or Home Manager modules:

```fish
cd ~/nixos-config
git add <changed-files>   # Flakes do not include newly-created untracked files
nix flake check --no-build
nix build --no-link .#nixosConfigurations.wsl.config.system.build.toplevel
sudo nixos-rebuild dry-activate --flake .#wsl
sudo nixos-rebuild switch --flake .#wsl
```

For Lua changes under `home/dotfiles/nvim/`, Neovim normally reads directly from the checked-out repository: no system rebuild is necessary. Commit `lazy-lock.json` and `lazyvim.json` whenever plugin revisions or enabled extras change. Plugin updates are intentional, not automatic.

For project-specific environments, use a reviewed `.envrc` containing `use flake` and run `direnv allow` once. Keep project `flake.lock`/`uv.lock` under version control; exclude `.direnv/` and `.venv/`.

To update Nix inputs deliberately:

```fish
nix flake update
nix flake check --no-build
nix build --no-link .#nixosConfigurations.wsl.config.system.build.toplevel
# Review flake.lock and test before switching.
```

## Security and reproducibility notes

- **Never commit** GitHub tokens, application secrets, private keys or `.env` credentials. Authentication is provisioned separately (for example via a password manager).
- `flake.lock` pins Nix inputs. `lazy-lock.json` pins LazyVim plugin revisions; `lazyvim.json` records LazyVim extras. The lazy.nvim bootstrap itself is pinned to a Git SHA.
- LazyVim plugin restoration and fetching package sources still require network availability; exact reproduction also depends on upstream sources remaining available.
- The Neovim symlink uses a fixed local repository path. Moving the checkout without adapting the Home Manager module breaks that link.
- The WSL distribution, underlying Windows environment and Windows Terminal configuration are **not provisioned by this flake**.
- `nix flake check` and a successful build are useful tests, but they **do not replace a genuine fresh-install recovery test**.

## Troubleshooting

**New file referenced by a flake is invisible:** `git add path/to/file` before building; committing is not required for local evaluation.

**`git tree is dirty` warning:** expected when tracked files differ from the committed revision; review those changes.

**Neovim config collision:** avoid configuring both a generated `~/.config/nvim/init.lua` and an out-of-store symlink for the whole `~/.config/nvim` directory.

**`direnv: unloading`:** normal when leaving a project directory with an authorized `.envrc`.

**tmux still has old bindings:** open a fresh tmux server/session or reload `~/.config/tmux/tmux.conf`.

**Windows clipboard does not work:** check whether `clip.exe` is available through WSL interoperability; this binding is not portable to native Linux.

## References

- [NixOS-WSL installation](https://nix-community.github.io/NixOS-WSL/install.html)
- [NixOS-WSL releases](https://github.com/nix-community/NixOS-WSL/releases)
- [NixOS manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager](https://nix-community.github.io/home-manager/)
- [LazyVim](https://www.lazyvim.org/)


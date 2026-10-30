# Installation laptop NixOS (Hyprland / Quickshell / Disko)

> WARNING: Disko's `destroy,format,mount` step **ERASES THE SELECTED DISK**.
> This laptop configuration must never be run against WSL's virtual disk.
> The branch is a proposal: no test on the user's real hardware has been run.

## Prerequisites

- x86_64 laptop, UEFI boot, Secure Boot **disabled for the first installation**.
- Network connection from NixOS live ISO.
- Disk identifiers confirmed with `lsblk -o NAME,SIZE,MODEL,TRAN` and `ls -l /dev/disk/by-id/`.
- Back up anything valuable off-device before proceeding.
- Clone into `/mnt/home/nixos/nixos-config` after install for Neovim's existing out-of-store symlink, or adjust `home/programs/neovim.nix`.

## Before a laptop install

1. Review `hosts/laptop/disko.nix` and **replace** `/dev/disk/by-id/REPLACE-WITH-LAPTOP-DISK`
   with the exact disk by-id for the laptop. Do not use the partition by-id.
2. Replace the bootstrap `hosts/laptop/hardware-configuration.nix` after reading the hardware
   configuration of the target machine. Preserve CPU firmware, initrd and GPU-specific details.
3. The proposed `flake.lock` pins Disko alongside the existing inputs. On a network-connected trusted machine:

   ```sh
   nix flake check --no-build
   nix build --no-link .#nixosConfigurations.wsl.config.system.build.toplevel
   nix build --no-link .#nixosConfigurations.laptop.config.system.build.toplevel
   ```

The WSL flake output is unchanged and its existing dependency revisions were preserved.
Verify both builds before any `switch`.

## On the live ISO (destructive)

Clone the reviewed branch and ensure `disko.nix` contains the correct device before running:

```sh
cd nixos-config
lsblk -o NAME,SIZE,MODEL,SERIAL,TYPE,MOUNTPOINTS
# Stop here unless the target disk is confirmed.
sudo nix run github:nix-community/disko -- --mode destroy,format,mount ./hosts/laptop/disko.nix
# Mountpoints should now be under /mnt.
findmnt -R /mnt
```

Generate actual hardware info without overwriting Disko's mount definitions:

```sh
sudo nixos-generate-config --root /mnt --no-filesystems
# Inspect /mnt/etc/nixos/hardware-configuration.nix; merge relevant device modules
# into hosts/laptop/hardware-configuration.nix in this Git checkout.
```

Set the password for `nixos` **before first login**:

```sh
sudo nixos-install --flake .#laptop
sudo nixos-enter --root /mnt -- passwd nixos
```

Install must use a flake checkout that includes the real disk path, hardware config and committed `flake.lock`. No secrets are tracked in Git. The login manager is Ly, the compositor
is Hyprland 0.55 (Lua) with UWSM, and Quickshell runs as the `ade` profile.

## Operations

- Terminal: `Super+Enter`.
- Quickshell application launcher: `Super+D`.
- Lock screen: `Super+L`; idle lock after 5 minutes.
- Workspace switch (AZERTY): `Super` + number-row key 1–5.
- Fullscreen: `Super+F`; close window: `Super+Q`.

No snapshot automation, secure boot enrollment, Restic/S3 backup, or hibernation has been set up.
There is no root rollback policy without additional work. Test USB peripherals, suspend,
Bluetooth, graphics and Wi-Fi before relying on this as a primary incident-response device.

{ lib, pkgs, ... }:
{
  imports = [
    ../../modules/nixos/common.nix
    ../../modules/nixos/desktop/default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "laptop";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr";

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.fish.enable = true;
  users.users.nixos = {
    isNormalUser = true;
    description = "NixOS user";
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.fish;
    # Intentionally no password or hashes in Git. Set with passwd during installation.
  };

  hardware.enableRedistributableFirmware = true;
  services.fstrim.enable = true;
  services.fwupd.enable = true;
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  environment.systemPackages = with pkgs; [
    git
    btrfs-progs
    cryptsetup
  ];

  # Replace the generic hardware file after probing the real laptop.
  system.stateVersion = "26.05";
}

# Bootstrap ONLY: replace this file with the hardware configuration
# generated on the actual laptop, and remove any generated fileSystems,
# swapDevices and boot.loader entries already owned by Disko.
{ lib, ... }:
{
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

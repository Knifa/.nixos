{ config, lib, pkgs, ... }:
{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/b73ee8d9-33db-4ea5-a0b8-bf2b7f19e248";
      fsType = "ext4";
      options = [ "discard" "relatime" "lazytime" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/1A10-7E0B";
      fsType = "vfat";
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/8d06de26-d71d-4fb4-aa83-92b3c53e372e";
  }];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usb_storage"
      "sd_mod"
    ];
    initrd.luks.devices."luks-7f40f957-1fe3-43a6-829e-40380aeb38c7".device = "/dev/disk/by-uuid/7f40f957-1fe3-43a6-829e-40380aeb38c7";
    initrd.luks.devices."luks-33c39253-254a-4c4a-9341-92c5d7d9d282".device = "/dev/disk/by-uuid/33c39253-254a-4c4a-9341-92c5d7d9d282";
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_zen;
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;
  };

  networking.hostName = "chinatsu";
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

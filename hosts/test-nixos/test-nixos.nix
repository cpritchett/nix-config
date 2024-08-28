{ config, lib, pkgs, inputs, modulesPath, ... }:
{
  imports =[
    # import custom modules
    inputs.self.nixosModules.cpritchett
    # import users
    (inputs.self + /users/admin)
    # hardware
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-cpu-intel
  ];
  config = {
    networking.hostName = "test-nixos";
    system.stateVersion = "23.11";
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" "virtio" "nvme" "vmd" "sr_mod" ];
    #boot.supportedFilesystems = [ "btrfs" "ext2" "ext3" "ext4" "exfat" "f2fs" "fat8" "fat16" "fat32" "ntfs" "xfs" ];
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    cpritchett = {
      tailscale = {
        enable = true;
        extraUpFlags = ["--ssh=true" "--reset=true" "--accept-dns=false" ];
        useRoutingFeatures = "client";
        authKeyFile = null;
      };
      adguardhome.enable = false;

      autoUpgrade.enable = false;
      primaryUser.users = [ "cpritchett" ];
      timezone.central= true;
      syncoid.enable = false;
      suites = {
        basics.enable = true;
        foundation.enable = true;
      };
      # disk configuration
      disks = {
        enable = true;
        systemd-boot = true;
        initrd-ssh = {
      	  enable = true;
          ethernetDrivers = ["virtio_net"];
        };
        zfs = {
          enable = true;
          hostID = "20ABD697";
          root = {
            encrypt = true;
            disk1 = "sda";
            impermanenceRoot = true;
          };
        };
      };
    };
  };
}

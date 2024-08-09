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
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    cpritchett = {
      tailscale = {
        enable = false;
        extraUpFlags = ["--ssh=true" "--reset=true" "--accept-dns=false" ];
        useRoutingFeatures = "client";
        authKeyFile = null;
      };
      adguardhome.enable = false;

      autoUpgrade.enable = true;
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
        zfs = {
          enable = true;
          hostID = "20ABD697";
          root = {
            encrypt = true;
            disk1 = "sda";
            impermanenceRoot = false;
          };
        };
      };
    };
  };
}
{ config, lib, pkgs, modulesPath, inputs, ... }:
let
  inherit (config.cpritchett.impermanence) dontBackup;
in
{
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
    ];
  age.secrets.cpritchett.file = (inputs.self + /secrets/cpritchett.age);

  users.mutableUsers = false;

  users.users.cpritchett = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "cpritchett";
    hashedPasswordFile = config.age.secrets.cpritchett.path;
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEApFR9UNrE2s+i/G/VPncNcR6y0bXzIpsNR2JlcASA9"
      ];
    packages = with pkgs; [];
  };

  environment.persistence."${dontBackup}" = {
    users.cpritchett = {
      directories = [
        "nix"
        "documents"
        ".var"
        ".config"
        ".local"
      ];
    files = [
    ];
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      # Import your home-manager configuration
      cpritchett = import ./homeManager;
    };
  };
}
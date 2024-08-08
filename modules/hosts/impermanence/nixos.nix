{ config, lib, pkgs, inputs, ... }:
with lib;
{
  # I have to do this so I can import it into multiple modules, because if I import it directly to multiple modules... it breaks
  imports = [inputs.impermanence.nixosModules.impermanence];


  options.cpritchett.impermanence = {
    backup = mkOption {
      type = types.str;
      default = "/persist/save";
      description = "The persistent directory to backup";
    };
    backupStorage = mkOption {
      type = types.str;
      default = "/persist/save";
      description = "The persistent directory to backup";
    };
    dontBackup = mkOption {
      type = types.str;
      default = "/persist";
      description = "The persistent directory to not backup";
    };
  };
  config = {
    cpritchett.impermanence.backup = mkIf config.cpritchett.disks.amReinstalling "/tmp";
    cpritchett.impermanence.backupStorage = mkIf config.cpritchett.disks.amReinstalling "/tmp";
  };
}
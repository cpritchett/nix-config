{ options, config, lib, pkgs, inputs, ... }:
let
  cfg = config.cpritchett.sanoid;
in
{
  options.cpritchett.sanoid = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        enable custom sanoid, zfs-snapshot module
      '';
    }; 
  };

  config = lib.mkIf cfg.enable {
    services.sanoid = {
      enable = true;
      templates = {
        default = {
          autosnap = true;
          autoprune = true;
          hourly = 8;
          daily = 1;
          monthly = 1;
          yearly = 1;
        };
      };
      datasets = {
        "zroot/persist".useTemplate = [ "default" ];
        "zroot/persistSave".useTemplate = [ "default" ];
      } // lib.optionalAttrs (config.cpritchett.disks.zfs.storage.enable && !config.cpritchett.disks.amReinstalling) {
        "zstorage/storage".useTemplate = [ "default" ];
        "zstorage/persistSave".useTemplate = [ "default" ];
      };
    };
  };
}
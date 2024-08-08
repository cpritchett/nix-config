{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.cpritchett.flatpak;
  inherit (config.cpritchett.impermanence) dontBackup;
in
{
  options.cpritchett.flatpak = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable custom flatpak module
      '';
    };
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;
    environment.persistence."${dontBackup}" = {
      hideMounts = true;
      directories = [
        "/var/lib/flatpak"
      ];
    };
  };
}
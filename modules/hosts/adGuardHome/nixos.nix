{ options, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.cpritchett.adguardhome;
  inherit (config.networking) hostName;
  inherit (config.cpritchett.impermanence) backup;
  inherit (config.cpritchett.tailscale) tailnetName;
in
{
  options.cpritchett.adguardhome = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable custom adGuard Home module
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.persistence."${backup}" = {
      directories = [
        "/var/lib"
      ];
    };
    services.adguardhome = {
      enable = true;
      allowDHCP = true;
    };
    cpritchett.homepage.groups.services.services = [{
      DNS = {
        icon = "si-adguard";
        href = "{{HOMEPAGE_VAR_ADGUARD_IP}}";
        widget = {
          type = "adguard";
          url = "http://${hostName}.${tailnetName}.ts.net";
          username = "{{HOMEPAGE_VAR_ADGUARD_USERNAME}}";
          password = "{{HOMEPAGE_VAR_ADGUARD_PASSWORD}}";
        };
      };
    }];
  };
}
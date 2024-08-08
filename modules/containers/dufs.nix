{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  ### Set container name and image
  NAME = "dufs";
  IMAGE = "docker.io/sigoden/dufs";

  cfg = config.cpritchett.pods.${NAME};
  inherit (config.networking) hostName;
  inherit (config.cpritchett.impermanence) backup;
  inherit (config.cpritchett.tailscale) tailnetName;

in
{
  options.cpritchett.pods.${NAME} = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable custom ${NAME} container module
      '';
    };
    volumeLocation = mkOption {
      type = types.str;
      default = "${backup}/containers/${NAME}";
      description = ''
        path to store container volumes
      '';
    };
    imageVersion = mkOption {
      type = types.str;
      default = "latest";
      description = ''
        container image version
      '';
    };
  };

  config = mkIf cfg.enable {

    systemd.tmpfiles.rules = ["d ${cfg.volumeLocation}/data 0755 4000 4000"];

    virtualisation.oci-containers.containers = {
      "${NAME}" = {
        image = "${IMAGE}:${cfg.imageVersion}";
        autoStart = true;
        volumes = [
          "${cfg.volumeLocation}/data:/data"
        ];
        extraOptions = [
          "--pull=always"
          "--network=container:TS${NAME}"
        ];
        user = "4000:4000";
        cmd = ["/data" "--allow-upload"];
      };
    };

    cpritchett.pods.tailscaled."TS${NAME}" = {
      TSserve =  {"/" = "http://127.0.0.1:5000";};
      tags = ["tag:generichttps"];
    };

    cpritchett.homepage.groups.services.services = [{
      "${NAME}" = {
        icon = "si-files";
        href = "https://${hostName}-${NAME}.${tailnetName}.ts.net";
        siteMonitor = "https://${hostName}-${NAME}.${tailnetName}.ts.net";
      };
    }];

    cpritchett.gatus.endpoints = [{
      name = "${hostName}-${NAME}";
      group = "webapps";
      url = "https://${hostName}-${NAME}.${tailnetName}.ts.net/";
      interval = "5m";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "ntfy";
          failureThreshold = 3;
          description = "healthcheck failed";
        }
      ];
    }];

  };
}
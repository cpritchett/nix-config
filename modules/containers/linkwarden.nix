
{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  ### Set container name and image
  NAME = "linkwarden";
  IMAGE = "ghcr.io/linkwarden/linkwarden";
  dbIMAGE = "docker.io/postgres";


  cfg = config.cpritchett.pods.${NAME};
  inherit (config.networking) hostName;
  inherit (config.cpritchett.impermanence) backup;
  inherit (config.cpritchett.impermanence) dontBackup;
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
    agenixSecret = mkOption {
      type = types.path;
      default = (inputs.self + /secrets/${NAME}EnvFile.age);
      description = ''
        path to agenix secret file
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
### database container
    database = {
      agenixSecret = mkOption {
        type = types.path;
        default = (inputs.self + /secrets/${NAME}DBEnvFile.age);
        description = ''
          path to agenix secret file
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
        default = "16-alpine";
        description = ''
          container image version
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    ### agenix secrets for container
    age.secrets."${NAME}EnvFile".file = cfg.agenixSecret;
    age.secrets."${NAME}DBEnvFile".file = cfg.database.agenixSecret;

    systemd.tmpfiles.rules = [
      # main container
      "d ${cfg.volumeLocation}/data 0755 4000 4000"
      # database container
      "d ${cfg.database.volumeLocation}/db 0755 root root"
    ];
    virtualisation.oci-containers.containers = {
### DB container
      "DB${NAME}" = {
        image = "${dbIMAGE}:${cfg.database.imageVersion}";
        autoStart = true;
        # environment = {
        #     "POSTGRES_PASSWORD" = "password";
        # };
        environmentFiles = [
          config.age.secrets."${NAME}DBEnvFile".path
            #  POSTGRES_PASSWORD=password #insert your secure database password!
        ];
        volumes = [
          "${cfg.database.volumeLocation}/db:/var/lib/postgresql/data"
        ];
        extraOptions = [
          "--pull=always"
          "--network=container:TS${NAME}"
        ];
      };
### main container
      "${NAME}" = {
        image = "${IMAGE}:${cfg.imageVersion}";
        autoStart = true;
        # environment = {    
        #   "DATABASE_URL" = "postgresql://postgres:password@127.0.0.1:5432/postgres";
        #   "NEXTAUTH_SECRET" = "password";
        #   "NEXTAUTH_URL" = "http://localhost:3000/api/v1/auth";
        # };
        environmentFiles = [
          config.age.secrets."${NAME}EnvFile".path 
              #  DATABASE_URL=postgresql://postgres:${POSTGRES_PASSWORD}@127.0.0.1:5432/postgres
              #  NEXTAUTH_SECRET=very_sensitive_secret
              #  NEXTAUTH_URL=http://localhost:3000/api/v1/auth
        ];
        volumes = [
          "${cfg.volumeLocation}/data:/data/data"
        ];
        extraOptions = [
          "--pull=always"
          "--network=container:TS${NAME}"
        ];
      };
    };
    cpritchett.pods.tailscaled."TS${NAME}" = {
      TSserve = {
        "/" = "http://127.0.0.1:3000";
      };
      tags = ["tag:generichttps"];
    };
    cpritchett.homepage.groups.services.services = [{
      "${NAME}" = {
        icon = "mdi-bookmark-box";
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

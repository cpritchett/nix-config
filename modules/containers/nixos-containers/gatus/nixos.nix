{ config, lib, pkgs, inputs, modulesPath, ... }:
let

  NAME = "gatus";

  cfg = config.cpritchett.nixos-containers."${NAME}";

  inherit (config.networking) hostName;
  inherit (config.cpritchett.impermanence) backup;
  inherit (config.cpritchett.impermanence) dontBackup;
  inherit (config.cpritchett.tailscale) tailnetName;
  inherit (config.system) stateVersion;
in
{
  options.cpritchett.nixos-containers."${NAME}".enable = lib.mkEnableOption (lib.mdDoc "${NAME} Server");

  config = lib.mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "d ${backup}/nixos-containers/${NAME}/data 0755 admin"
      "d ${dontBackup}/nixos-containers/${NAME}/tailscale"
    ];

    cpritchett.homepage.groups.services.services = [{
      "${NAME}" = {
        icon = "mdi-list-status";
        href = "https://${hostName}-${NAME}.${tailnetName}.ts.net/";
        siteMonitor = "https://${hostName}-${NAME}.${tailnetName}.ts.net/";
      };
    }];

    #will still need to set the network device name manually
    cpritchett.network.useBr0 = true;

    containers."${hostName}-${NAME}" = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0"; # Specify the bridge name
      specialArgs = { inherit inputs; };
      bindMounts = { 
        "/etc/ssh/${hostName}" = { 
          hostPath = "/etc/ssh/${hostName}";
          isReadOnly = true; 
        };
        "/var/lib/tailscale/" = {
          hostPath = "${dontBackup}/nixos-containers/${NAME}/tailscale";
          isReadOnly = false; 
        };
        "/var/lib/gatus/data" = {
          hostPath = "${backup}/nixos-containers/${NAME}/data";
          isReadOnly = false; 
        };
      };
      enableTun = true;
      ephemeral = true;
      config = {
        imports = [
          inputs.self.nixosModules.cpritchett
          (inputs.self + /users/admin)
        ];
        system.stateVersion = stateVersion;
        age.identityPaths = ["/etc/ssh/${hostName}"];

        cpritchett = {
          suites = {
            container.enable = true;
            };
          tailscale = {
            enable = true;
            extraUpFlags = ["--ssh=true" "--reset=true"];
          };
        };

        environment.persistence."${dontBackup}".users.admin = lib.mkForce {};

        systemd.tmpfiles.rules = [
          "d /var/lib/gatus/data 0755 gatus"
        ];

        cpritchett.gatus.enable = true;
        services.gatus = {
          enable = true;
          settings ={
            web.port = 8080;
            storage = {
              type = "sqlite";
              path = "/var/lib/gatus/data/data.db";
            };
            endpoints = [{
              name = "gatus";
              group = "webapps";
              url = "https://${hostName}-${NAME}.${tailnetName}.ts.net";
              interval = "5m";
              conditions = [
                "[CONNECTED] == true"
              ];
              # alerts = [
              #   {
              #     type = "ntfy";
              #     failureThreshold = 3;
              #     description = "default check";
              #   }
              # ];
            }];
            alerting = {
              ntfy = {
                url = "${config.cpritchett.ntfy.ntfyUrl}";
                topic = "${config.cpritchett.ntfy.defaultTopic}";
                priority = 3;
                default-alert = {
                  enable = true;
                  failure-threshold = 10;
                  success-threshold = 10;
                  send-on-resolved = true;
                };
              };
            };
          };
        };

        ## example of how to add a gatus monitor in another module
        # cpritchett.gatus.endpoints = [{
        #   name = "gatus test test";
        #   group = "webapps";
        #   url = "https://${hostName}-${NAME}.${tailnetName}.ts.net/";
        #   interval = "5s";
        #   conditions = [
        #     "[CONNECTED] == true"
        #   ];
        #   alerts = [
        #     {
        #       type = "ntfy";
        #       failureThreshold = 3;
        #       description = "healthcheck failed";
        #     }
        #   ];
        # }];

        services.caddy = {
          enable = true;
          virtualHosts."${hostName}-${NAME}.${tailnetName}.ts.net".extraConfig = ''
            reverse_proxy 127.0.0.1:8080
          '';
        };
      };
    };
  };
}
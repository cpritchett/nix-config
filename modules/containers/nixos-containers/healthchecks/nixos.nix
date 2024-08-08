{ config, lib, pkgs, inputs, modulesPath, ... }:
let

  NAME = "healthchecks";

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

    age.secrets.healthchecks.file = ( inputs.self + /secrets/healthchecks.age);


    systemd.tmpfiles.rules = [
      "d ${dontBackup}/nixos-containers/${NAME}/tailscale"
      "d ${backup}/nixos-containers/${NAME}/data 0755 admin"
    ];

    cpritchett.homepage.groups.services.services = [{
      "${NAME}" = {
        icon = "mdi-bell-badge";
        href = "https://${hostName}-${NAME}.${tailnetName}.ts.net/";
        siteMonitor = "https://${hostName}-${NAME}.${tailnetName}.ts.net/";
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
        "/var/lib/healthchecks/" = {
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

        age.secrets.healthchecks.file = ( inputs.self + /secrets/healthchecks.age);

        cpritchett.healthchecks = {
          enable = true;
          settings.ALLOWED_HOSTS = ["${hostName}-${NAME}.${tailnetName}.ts.net"];
          settings.SITE_ROOT = "https://${hostName}-${NAME}.${tailnetName}.ts.net";
          settings.REGISTRATION_OPEN = true;
          settingsFile = config.containers."${hostName}-${NAME}".config.age.secrets.healthchecks.path;
        };

        services.caddy = {
          enable = true;
          virtualHosts."${hostName}-${NAME}.${tailnetName}.ts.net".extraConfig = ''
            reverse_proxy 127.0.0.1:8000
          '';
        };
      };
    };
  };
}
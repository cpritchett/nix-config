{ config, lib, pkgs, inputs, modulesPath, ... }:
let

  NAME = "homepage";

  cfg = config.cpritchett.nixos-containers."${NAME}";

  inherit (config.networking) hostName;
  inherit (config.cpritchett.impermanence) backup;
  inherit (config.cpritchett.impermanence) dontBackup;
  inherit (config.cpritchett.impermanence) backupStorage;
  inherit (config.cpritchett.tailscale) tailnetName;
  inherit (config.system) stateVersion;

in
{
  options.cpritchett.nixos-containers."${NAME}" = {
    enable = lib.mkEnableOption (lib.mdDoc "${NAME} Server");
    storage = lib.mkOption {
      description = "persistent file location";
      type = lib.types.str;
      default = dontBackup;
    };
  };

  config = lib.mkIf cfg.enable {

    cpritchett.homepage.enable = true;


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

    systemd.tmpfiles.rules = [
      "d ${cfg.storage}/nixos-containers/${NAME}/tailscale"
    ];

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
        "/var/lib/tailscale" = {
          hostPath = "${cfg.storage}/nixos-containers/${NAME}/tailscale";
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
          tailscale.extraUpFlags = ["--ssh=true" "--reset=true"];
          suites.container.enable = true;
          # homepage-dashboard.enable = true;
          homepage.enable = true;
        };
        services.homepage-dashboard.enable = true;

        systemd.tmpfiles.rules = [
          "d /etc/homepage-dashboard/logs"
        ];
        services.caddy = {
          enable = true;
          virtualHosts."${hostName}-${NAME}.${tailnetName}.ts.net".extraConfig = ''
            reverse_proxy 127.0.0.1:8082
          '';
        };
      };
    };
  };
}
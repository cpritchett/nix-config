
## currently "pkgs.vscode-with-extensions.override" does not appear to be working right now.



{ config, lib, pkgs, inputs, modulesPath, ... }:
let

  NAME = "code-server";

  cfg = config.cpritchett.nixos-containers."${NAME}";

  inherit (config.networking) hostName;
  inherit (config.cpritchett.impermanence) backup;
  inherit (config.cpritchett.impermanence) dontBackup;
  inherit (config.cpritchett.tailscale) tailnetName;
  inherit (config.system) stateVersion;
in
{
  options.cpritchett.nixos-containers."${NAME}".enable = lib.mkEnableOption (lib.mdDoc "Code Server");

  config = lib.mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "d ${dontBackup}/nixos-containers/${NAME}/tailscale"
      "d ${dontBackup}/nixos-containers/${NAME}/userdata 0755 admin"
      "d ${dontBackup}/nixos-containers/${NAME}/extensions 0755 admin"
      "d ${dontBackup}/nixos-containers/${NAME}/admin 0755 admin"
    ];


    cpritchett.homepage.groups.services.services = [{
      "Code Server" = {
        icon = "si-visualstudiocode";
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
        "${dontBackup}/nixos-containers/${NAME}/userdata" = {
          hostPath = "${dontBackup}/nixos-containers/${NAME}/userdata";
          isReadOnly = false; 
        };
        "${dontBackup}/nixos-containers/${NAME}/extensions" = {
          hostPath = "${dontBackup}/nixos-containers/${NAME}/extensions";
          isReadOnly = false; 
        };
        "/home/admin" = {
          hostPath = "${dontBackup}/nixos-containers/${NAME}/admin";
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

        services.code-server = {
          enable = true;
          user = "admin";
          auth = "none";
          # hashedPassword
          userDataDir = "${dontBackup}/nixos-containers/${NAME}/userdata";
          # disableGettingStartedOverride = true;
          disableTelemetry = true;
          disableUpdateCheck = true;
          disableWorkspaceTrust = true;
          extensionsDir = "${dontBackup}/nixos-containers/${NAME}/extensions";
          host = "127.0.0.1";
          port = 3000;
          package = pkgs.vscode-with-extensions.override {
            vscode = pkgs.code-server;
            vscodeExtensions = with pkgs.vscode-extensions; [
              bbenoist.nix
              dracula-theme.theme-dracula
              ms-python.python
            ];
          };
        };

        services.caddy = {
          enable = true;
          virtualHosts."${hostName}-${NAME}.${tailnetName}.ts.net".extraConfig = ''
            reverse_proxy 127.0.0.1:3000
          '';
        };

      };
    };
  };
}
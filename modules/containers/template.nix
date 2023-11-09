{ options, config, lib, pkgs, ... }:

with lib;
let
  ### Set container name
  NAME = tailscale;
  cfg = config.yomaq.pods.${NAME};
in
{
  options.yomaq.pods.${NAME} = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable custom ${NAME} container module
      '';
    };
    agenixSecret = mkOption {
      type = types.str;
      default = "(inputs.self + /secrets/${NAME}EnvFile.age)";
      description = ''
        path to agenix secret file
      '';
    };
    volumeLocation = mkOption {
      type = types.str;
      default = "/nix/persistent/backup/containers/${NAME}";
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
    TSargs = mkOption {
      type = types.str;
      default = "";
      description = ''
        TS_Extra_ARGS env var
      '';
    };
    TShostname = mkOption {
      type = types.str;
      default = "tailscale";
      description = ''
        TS_HOSTNAME env var
      '';
    };
  };




  config = mkIf cfg.enable {
    ### agenix secrets for container
    age.secrets.${NAME}EnvFile.file = cfg.agenixSecret;

  # make the directories where the volumes are stored
  # it says "tmpfiles" but we don't add rules to remove the tmp file, so its... not tmp?
  # https://discourse.nixos.org/t/creating-directories-and-files-declararively/9349
  # storing volumes in the nix directory because we assume impermanance is wiping root
    systemd.tmpfiles.rules = [
      "d  ${cfg.volumeLocation}/data-lib 0755 root root"
      "d ${cfg.volumeLocation}/dev-net-tun 0755 root root"
    ];
    virtualisation.oci-containers.containers = {
      pihole = {
        image = "pihole/pihole:${cfg.imageVersion}";
        autoStart = true;
        environment = {
        "TS_HOSTNAME" =cfg.TShostname;
        "TS_STATE_DIR"= "/var/lib/tailscale";
        "TS_EXTRA_ARGS" = cfg.tailscaleArgs;
        "TS_ACCEPT_DNS" = "true"
        };
        environmentFiles = [
          # need to set "TS_AUTHKEY=key" in agenix and import here
          config.age.secrets.${NAME}EnvFile.path
        ];
        volumes = [
          "${cfg.volumeLocation}/data-lib:/var/lib"
          "${cfg.volumeLocation}/dev-net-tun:/dev/net/tun"
        ];
        extraOptions = [
          "--pull=newer"
          "--network=host"
          "--cap-add=NET_ADMIN"
          "--cap-add=NET_RAW"
        ];
      };
    };
  };
}
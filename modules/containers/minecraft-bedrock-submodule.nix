{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  ### Set container name and image
  NAME = "minecraftBedrock";
  IMAGE = "docker.io/itzg/minecraft-bedrock-server";

  cfg = config.cpritchett.pods.minecraftBedrock;
  inherit (config.networking) hostName;
  inherit (config.cpritchett.impermanence) backup;
  inherit (config.cpritchett.tailscale) tailnetName;


  containerOpts = { name, config, ... }: 
  let
    startsWith = substring 0 9 name == "minecraft";
    shortName = if startsWith then substring 9 (-1) name else name;
  in
  {
    options = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable custom ${NAME} container module
        '';
      };
      volumeLocation = mkOption {
        type = types.str;
        default = "${backup}/containers/minecraft/bedrock/${name}";
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
      serverName = mkOption {
        type = types.str;
        default = "${shortName}";
        description = ''
          serverName
        '';
      };
      envVariables = mkOption {
        type = types.attrsOf types.str;
        default = {
          "EULA" = "TRUE";
          "gamemode" = "survival";
          "difficulty" = "hard";
          "allow-cheats" = "true";
          "max-players" = "10";
          "view-distance" = "50";
          "tick-distance" = "4";
          "TEXTUREPACK_REQUIRED" = "true";
        };
        description = ''
          set custom environment variables for the bedrock container
        '';
      };
    };
  };
  mkContainer = name: cfg: {
    image = "${IMAGE}:${cfg.imageVersion}";
    autoStart = true;
    environment = lib.mkMerge [
    cfg.envVariables
    { "SERVER_NAME" = "${cfg.serverName}"; }
    ];
    volumes = ["${cfg.volumeLocation}/data:/data"];
    extraOptions = [
      "--pull=always"
      "--network=container:TS${name}"
    ];
    user = "4000:4000";
  };
  mkTmpfilesRules = name: cfg: [
    "d ${cfg.volumeLocation}/data 0755 4000 4000"
  ];
  containersList = attrNames cfg;
  renameTScontainers = map (a: "TS" + a) containersList;

  homepageServices = name:  [{
      "${name}" = {
        icon = "si-minecraft";
        href = "https://${hostName}-${name}.${tailnetName}.ts.net";
        widget = {
          type = "gamedig";
          serverType = "minecraftbe";
          url = "udp://${hostName}-${name}.${tailnetName}.ts.net:19132";
          fields = [ "status" "players" "ping" ];
        };
    };
  }];
in
{
  options.cpritchett.pods = {
    minecraftBedrock = mkOption {
      default = {};
      type = with types; attrsOf (submodule containerOpts);
      example = {};
      description = lib.mdDoc ''
        Minecraft Bedrock Server
      '';
    };
  };
  config = mkIf (cfg != {}) {
    cpritchett.pods.tailscaled = lib.genAttrs renameTScontainers (container: { tags = ["tag:minecraft"]; });
    systemd.tmpfiles.rules = lib.flatten ( lib.mapAttrsToList (name: cfg: mkTmpfilesRules name cfg) config.cpritchett.pods.minecraftBedrock);
    virtualisation.oci-containers.containers = lib.mapAttrs mkContainer config.cpritchett.pods.minecraftBedrock;
    # cpritchett.homepage.widgets = lib.flatten (map homepageWidgets containersList);
    cpritchett.homepage.services = [{minecraft = lib.flatten (map homepageServices containersList);}];
    cpritchett.homepage.settings.layout.minecraft.tab = "Services";
  };
}
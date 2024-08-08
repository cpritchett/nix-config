{ options, config, lib, pkgs, inputs, ... }:

# why am I not just using the tailscale service directly? ... idk, it auto configures the authKeyFile?

with lib;
let
  cfg = config.cpritchett.tailscale;
in
{
  options.cpritchett.tailscale = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable custom tailscale module
      '';
    };
    extraUpFlags = mkOption {
      type = types.listOf types.str;
      default = ["--ssh=true" "--reset=true" "--accept-dns=true"];
      description = ''
        Extra flags to pass to tailscale up.
      '';
    };
    useRoutingFeatures = mkOption {
      type = types.enum [ "none" "client" "server" "both" ];
      default = "none";
      example = "server";
      description = lib.mdDoc ''
        Enables settings required for Tailscale's routing features like subnet routers and exit nodes.

        To use these these features, you will still need to call `sudo tailscale up` with the relevant flags like `--advertise-exit-node` and `--exit-node`.

        When set to `client` or `both`, reverse path filtering will be set to loose instead of strict.
        When set to `server` or `both`, IP forwarding will be enabled.
      '';
    };
    tailnetName = mkOption {
      type = types.str;
      default = "";
      description = ''
        The name of the tailnet
      '';
    };
    authKeyFile = mkOption {
      type = types.nullOr types.path;
      default = "${config.age.secrets.tailscaleKey.path}";
      description = ''
        allow you to specify a key, or set null to disable
      '';
    };
    preApprovedSshAuthkey = mkOption {
      type = types.bool;
      default = false;
      description = ''
        decrypt pre-approved ssh authkey
      '';
    };
  };
}
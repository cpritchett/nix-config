{ options, config, lib, pkgs, inputs, ... }:


with lib;
let
  cfg = config.cpritchett.tailscale;

  inherit (config.networking) hostName;
in
{
 config = mkMerge [
  (lib.mkIf cfg.enable {
    services.tailscale = {
      package = pkgs.unstable.tailscale;
      enable = true;
      authKeyFile = cfg.authKeyFile;
      extraUpFlags = cfg.extraUpFlags;
      useRoutingFeatures = cfg.useRoutingFeatures;
      permitCertUid = "caddy";
    };

    environment.persistence."${config.cpritchett.impermanence.dontBackup}" = {
      hideMounts = true;
      directories = [
        "/var/lib/tailscale"
      ];
    };
    cpritchett.tailscale.tailnetName = "lynx-justice";
    age.secrets.tailscaleKey.file = ( inputs.self + /secrets/tailscaleKey.age);

    environment.systemPackages = with pkgs; [
      unstable.tailscale
    ];

  })
  (lib.mkIf cfg.preApprovedSshAuthkey {
    age.secrets.tailscaleOAuthKeyAcceptSsh.file = ( inputs.self + /secrets/tailscaleOAuthKeyAcceptSsh.age);
  })];
}
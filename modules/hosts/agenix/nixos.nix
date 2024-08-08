{ config, lib, pkgs, inputs, ... }:
let
  inherit (config.networking) hostName;
  cfg = config.cpritchett.agenix;
in
{
  imports = [ inputs.agenix.nixosModules.default ];
  config = lib.mkIf cfg.enable {
      age.identityPaths = [ "/etc/ssh/${hostName}" ];
  };
}
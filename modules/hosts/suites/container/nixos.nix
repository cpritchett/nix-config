{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.cpritchett.suites.container;
in
{
  options.cpritchett.suites.container = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
      '';
    };
  };

  config = mkIf cfg.enable {
    cpritchett = {
      zsh.enable =true;
      agenix.enable = true;
      nixSettings.enable = true;
      tailscale.enable = true;
    };
    networking.useHostResolvConf = lib.mkForce false;
    networking.useDHCP = lib.mkForce true;

  };
}
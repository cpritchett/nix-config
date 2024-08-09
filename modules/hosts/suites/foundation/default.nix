{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.cpritchett.suites.foundation;
in
{
  options.cpritchett.suites.foundation = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
      '';
    };
  };

  config = mkIf cfg.enable {
    cpritchett = {
      zsh.enable = true;
      agenix.enable = true;
      nixSettings.enable = true;
      tailscale.enable = false;
      network.basics = true;
    };
  };
}

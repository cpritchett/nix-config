{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.cpritchett.suites.foundation;
in
{
  config = mkIf cfg.enable {
    cpritchett = {
      initrd-tailscale.enable = true;
    };
  };
}
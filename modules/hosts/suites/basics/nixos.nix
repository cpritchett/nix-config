{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.cpritchett.suites.basics;
in
{
  config = mkIf cfg.enable {
    cpritchett = {
      glances.enable = true;
    };
  };
}
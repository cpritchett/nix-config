{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.cpritchett.suites.basics;
in
{
  imports = [
  ];
  config = mkIf cfg.enable {
    cpritchett = {
      skhd.enable = true;
    };
  };
}
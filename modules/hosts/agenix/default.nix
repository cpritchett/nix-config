{ options, config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.cpritchett.agenix;
in
{
  options.cpritchett.agenix = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable custom agenix module
      '';
    };
  };
}
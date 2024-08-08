{ options, config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.cpritchett.zsh;
in
{
  options.cpritchett.zsh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable custom zsh module
      '';
    };
  };
}
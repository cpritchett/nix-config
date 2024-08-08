{ options, config, lib, pkgs, ... }:
let
  cfg = config.cpritchett._1password;
in
{
  options.cpritchett._1password = {
    enable = with lib; mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable custom 1password module
      '';
    };
  };
}
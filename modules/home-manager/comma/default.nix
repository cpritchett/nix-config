{ options, config, lib, pkgs, inputs, ... }:
let
  cfg = config.cpritchett.comma;
in
{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];
  options.cpritchett.comma = {
    enable = with lib; mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable custom comma module
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    programs.nix-index-database.comma.enable = true;
  };
}
{ options, config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.cpritchett.scripts;
in
{
  options.cpritchett.scripts = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        install custom scripts
      '';
    };
  };


 config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (import (inputs.self + /modules/scripts/initrdunlock.nix) {inherit pkgs inputs;})
    ];
 };
}
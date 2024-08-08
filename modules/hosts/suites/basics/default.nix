{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.cpritchett.suites.basics;
in
{
  imports = [
  ];
  options.cpritchett.suites.basics = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
      '';
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.agenix.overlays.default ];
    environment.systemPackages = with pkgs; [
      vim
      git
      agenix
      just
      nixos-rebuild
    ];
  };
}
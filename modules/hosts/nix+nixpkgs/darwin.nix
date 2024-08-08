{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.cpritchett.nixSettings;
in
{
  imports = [
    # this apparently needs to say nixos instead of darwin
    inputs.lix.nixosModules.default
  ];
  config = mkIf cfg.enable {
    nix = {
      gc = {
        automatic = true;
        interval.Hour = 1;
        options = "--delete-older-than 30d";
      };
  #Nix Store config, hard linking identical dependancies etc.
      settings = {
        auto-optimise-store = true;
        allowed-users = [
          "cpritchett"
        ];
      };
    };
    services.nix-daemon.enable = true;
    #At the time of making the config nix breaks when darwin documentation is enabled.
    documentation.enable = false;
  };
}
{ options, config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.cpritchett.network;
in
{
  config = mkIf cfg.basics {
    networking = {
      knownNetworkServices = [
        ''
          [
            "USB 10/100/1000 LAN"
            "Thunderbolt Bridge"
            "Wi-Fi"
          ]
        ''
      ];
    };
  };
}
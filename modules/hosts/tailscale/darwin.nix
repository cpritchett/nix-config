{ options, config, lib, pkgs, inputs, ... }:

# why am I not just using the tailscale service directly? ... idk, it auto configures the authKeyFile?

with lib;
let
  cfg = config.cpritchett.tailscale;
in
{
 config = lib.mkIf cfg.enable {
     homebrew.casks = [
       "tailscale"
     ];
  };
}
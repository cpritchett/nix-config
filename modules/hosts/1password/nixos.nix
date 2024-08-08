{ options, config, lib, pkgs, ... }:
let
  cfg = config.cpritchett._1password;
in
{
  config = lib.mkIf cfg.enable {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = config.cpritchett.primaryUser.users;
    };
  };
}
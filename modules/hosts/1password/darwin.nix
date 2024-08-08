{ options, config, lib, pkgs, ... }:
let
  cfg = config.cpritchett._1password;
in
{
 config = lib.mkIf cfg.enable {
  homebrew.casks = [
    "1password"
    "1password-cli"
  ];
 };
}
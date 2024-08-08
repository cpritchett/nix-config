{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.cpritchett.zsh;
in
{
 config = lib.mkIf cfg.enable {
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh];
 };
}
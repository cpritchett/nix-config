{ options, config, lib, pkgs, inputs, ... }:
let
  cfg = config.cpritchett.tmux;
in
{
  imports = [];
  options.cpritchett.tmux = {
    enable = with lib; mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable custom tmux module
      '';
    };
  };
 config = lib.mkIf cfg.enable {
   programs = {
     tmux = {
       enable = true;
       shell = if pkgs ? zsh then "${pkgs.zsh}/bin/zsh" else "${pkgs.bash}/bin/bash";
     };
   };
 };
}

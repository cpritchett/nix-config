{ options, config, lib, pkgs, inputs, ... }:
let
  cfg = config.cpritchett.suites.basic;
in
{
  imports = [];
  options.cpritchett.suites.basic = {
    enable = with lib; mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable custom suite
      '';
    };
  };
 config = lib.mkIf cfg.enable {
    cpritchett = {
      comma.enable = true;
      bash.enable = true;
      tmux.enable = true;
      zsh.enable = true;
      direnv.enable = true;
    };
    home.packages = with pkgs; [ 
      devenv 
    ];
 };
}

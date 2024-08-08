{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.cpritchett.skhd;
in
{
  options.cpritchett.skhd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable custom skhd module
      '';
    };
  };

  config = mkIf cfg.enable {
    services = {
      skhd = {
        enable = true;
        skhdConfig = ''
          alt + cmd - return  : open -na ${pkgs.alacritty}/Applications/Alacritty.app
        '';
      };
    };
  };
}

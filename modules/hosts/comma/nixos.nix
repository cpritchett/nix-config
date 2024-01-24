{ options, config, lib, pkgs, inputs, ... }:
let
  cfg = config.yomaq.comma;
in
{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];
 config = lib.mkIf cfg.enable {
  programs.nix-index-database.comma.enable = true;
 };
}
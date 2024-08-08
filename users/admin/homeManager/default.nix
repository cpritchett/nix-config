{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.self.homeManagerModules.cpritchett
    ];
# https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    vim
    gh
    agenix
    just
  ];
  programs = {
    git = {
      enable = true;
      userEmail = "chad@chadpritchett.com";
      userName = "cpritchett";
    };
  };
  cpritchett = {
    suites.basic.enable = true;
    nixvim.enable = true;
  };
}

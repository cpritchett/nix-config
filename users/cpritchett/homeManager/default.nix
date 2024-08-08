{ inputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.self.homeManagerModules.cpritchett
    # inputs.nix-index-database.hmModules.nix-index
    ./dotfiles
    ];
# https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
  home.packages = [
### nixos + darwin packages
    pkgs.tailscale
    pkgs.discord
    pkgs.alacritty
    pkgs.vim
    pkgs.kubectl
    pkgs.nerdfonts
    pkgs.chezmoi
    pkgs.tmuxinator
    pkgs.kubernetes-helm
    # pkgs.agenix
    pkgs.git
    pkgs.gh
    pkgs.gitkraken
  ] ++ (lib.optionals (pkgs.system != "aarch64-darwin") [
### nixos specific packages
    pkgs.trayscale
    pkgs.nextcloud-client
    #pkgs.spotify
    pkgs.steam
    #screenshare x11 apps on wayland
    pkgs.xwaylandvideobridge
    # pkgs.obsidian
  ]);
  programs = {
    git = {
      enable = true;
      userEmail = "chad@chadpritchett.com";
      userName = "cpritchett";
    };
  };
  cpritchett = {
    suites.basic.enable = true;
    gnomeOptions.enable = true;
    vscode.enable = true;
    alacritty.enable = true;
    nixvim.enable = true;
  };
}

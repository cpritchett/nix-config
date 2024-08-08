{ inputs, lib, config, pkgs, ... }: 
let
  hostname = "test-macos";
in
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.self.darwinModules.cpritchett
    {home-manager.useUserPackages = true;}
  ];

  config = {
    system.stateVersion = 4;
    networking = {
      computerName = hostname;
      localHostName = hostname;
    };
    system = {
      defaults = {
        smb = {
          NetBIOSName = hostname;
          ServerDescription = hostname;
        };
      };
    };
    home-manager = {
      extraSpecialArgs = { inherit inputs; };
      users = {
        # Import your home-manager configuration
        cpritchett = import ../../users/cpritchett/homeManager;
      };
    };
    cpritchett = {
      yabai.enable = true;
      tailscale.enable = true;
      _1password.enable = true;
      scripts.enable = true;
      suites = {
        basics.enable = true;
        foundation.enable = true;
      };
      agenix.enable = lib.mkDefault false;
    };
  };
}




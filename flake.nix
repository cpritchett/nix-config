{
  description = "nix config";
  inputs = {
    # Nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; 
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Nix-Darwin
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    # Secret Encription
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    # Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Impermanance
    impermanence.url = "github:nix-community/impermanence";
    # Disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    # nix index for comma
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    # nixos generators
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    # nixvim
    nixvim.url = "github:nix-community/nixvim/nixos-24.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    # devenv
    devenv.url = "github:cachix/devenv";
    # flake.parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    # lix
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, nix-darwin, nixos-generators, flake-parts, ... }@inputs: 
  flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [
      # systems for which you want to build the `perSystem` attributes
      "x86_64-linux"
      "aarch64-darwin"
    ];
    imports = [
      inputs.devenv.flakeModule
    ];
    perSystem = { config, self', inputs', pkgs, system, ... }: {
      # flake's own devenv
      devenv.shells.default = { imports = [ ./Utilities/devenv/default.nix ]; };
    };
    # non-flake.parts outputs
    flake = {
      overlays = import ./modules/overlays {inherit inputs;};
  ### Host outputs
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild switch --flake .#your-hostname'
      nixosConfigurations = {
        zephyr = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; }; 
          modules = [ ./hosts/zephyr ];
        };
        test-nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; }; 
          modules = [ ./hosts/test-nixos ];
        };
        test-macos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; }; 
          modules = [ ./hosts/test-macos];
        };
        flotilla = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; }; 
          modules = [ ./hosts/flotilla ];
        };        
        # green = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = { inherit inputs; }; 
        #   modules = [ ./hosts/green ];
        # };
        # pearl = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = { inherit inputs; }; 
        #   modules = [ ./hosts/pearl ];
        # };
      };
      # Nix-darwin configuration entrypoint
      # Available through 'darwin-rebuild switch --flake .#your-hostname'
      #darwinConfigurations = {
      #  midnight = nix-darwin.lib.darwinSystem {
      #    specialArgs = { inherit inputs; };
      #    system = "aarch64-darwin"; 
      #    modules = [ ./hosts/midnight ];
      #  };
      #};
      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "cpritchett@hostname" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit inputs;};
          modules = [./users/cpritchett/homeManager];
        };
      };
      # Nixos-generators configuration entrypoints
      # Available through 'nix build .#your-hostname'
      packages.x86_64-linux = {
        #### requires --impure, breaks `nix flake check`
        # install-iso = nixos-generators.nixosGenerate {
        #   system = "x86_64-linux";
        #   format = "install-iso";
        #   specialArgs = { inherit inputs; };
        #   modules = [ ./hosts/install-iso ];
        # };
      };
  ### Module outputs
      nixosModules = {
        cpritchett = import ./modules/hosts/nixos.nix;
        # custom container modules
        pods = import ./modules/containers;
      };
      darwinModules = {
        cpritchett = import ./modules/hosts/darwin.nix;
      };
      homeManagerModules = {
        cpritchett = import ./modules/home-manager;
      };
    };
  };
}

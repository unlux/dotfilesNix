{
  description = "i've spent way too much time on nix";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # spicetify-nix.url = "github:the-argus/spicetify-nix";
    # hardware.url = "github:nixos/nixos-hardware";

    ghostty = {url = "github:ghostty-org/ghostty";};
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    ghostty,
    disko,
    # spicetify-nix,
    ...
  }: let
    inherit (self) outputs;
    system = "x86_64-linux";
    # lib = inputs.nixpkgs-stable.lib;
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    # pkgs-unstable = import inputs.nixpkgs-unstable.legacyPackages.${system};
    # pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};

    pkgs-stable = import inputs.nixpkgs-stable {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
  in
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    # forAllSystems = nixpkgs.lib.genAttrs systems;
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixpkgs.config = {
        allowUnfree.enable = true;
        allowUnfreePredicate = _: true;
      };

      nixosConfigurations = {
        leptup = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            hostname = "leptup";
            inherit inputs outputs pkgs-stable;
          };
          modules = [
	    disko.nixosModules.disko
            # > Our main nixos configuration file <
            ./hosts/leptup.nix
            ./hosts/disk.nix
            {
          _module.args.disks = [ "/dev/nvme0n1" ];
       		 }
            inputs.home-manager.nixosModules.default
            {
              environment.systemPackages = [
                ghostty.packages.x86_64-linux.default
              ];
            }
          ];
        };
        pc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            hostname = "pc";
            inherit inputs outputs pkgs-stable;
          };
          modules = [
            # > Our main nixos configuration file <
            ./hosts/pc.nix
            # inputs.home-manager.nixosModules.default
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "lux@leptup" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          pkgs-stable = nixpkgs-stable.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs pkgs-stable;
          }; # add spicetify-nix to the inherit
          modules = [
            # > Our main home-manager configuration file <
            ./hosts/home.nix
            # ./modules/spicetify/default.nix
          ];
        };
      };
    };
}

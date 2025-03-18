{
  description = "i've spent way too much time on nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # spicetify-nix.url = "github:the-argus/spicetify-nix";
    # hardware.url = "github:nixos/nixos-hardware";

    ghostty = {url = "github:ghostty-org/ghostty";};
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/thiagokokada/nix-alien
    nix-alien.url = "github:thiagokokada/nix-alien";
    stylix.url = "github:danth/stylix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    # spicetify-nix,
    ghostty,
    disko,
    nix-alien,
    stylix,
    ...
  }: let
    inherit (self) outputs;
    system = "x86_64-linux";

    # The main package set (nixos-unstable)
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # A secondary package set (nixos-24.05) for stable versions
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      leptup = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          hostname = "leptup";
          inherit inputs outputs pkgs-stable;
        };
        modules = [
          disko.nixosModules.disko
          stylix.nixosModules.stylix
          ./hosts/leptup.nix # > Our main nixos configuration file
          ./hosts/disk.nix # disko config file
          ({
            self,
            system,
            ...
          }: {
            environment.systemPackages = with self.inputs.nix-alien.packages.${system}; [
              nix-alien
            ];
          })
          {
            _module.args.disks = ["/dev/nvme0n1"];
          }
          {
            environment.systemPackages = [
              ghostty.packages.x86_64-linux.default
            ];
          }
        ];
      };
      # pc = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   specialArgs = {
      #     hostname = "pc";
      #     inherit inputs outputs;
      #   };
      #   modules = [
      #     # > Our main nixos configuration file <
      #     ./hosts/pc.nix
      #     # inputs.home-manager.nixosModules.default
      #   ];
      # };
    };

    # Standalone home-manager configuration entrypoint
    homeConfigurations = {
      "lux@leptup" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        pkgs-stable = nixpkgs-stable.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs pkgs pkgs-stable;
        };
        modules = [
          ./hosts/home.nix
          # stylix.homeManagerModules.stylix
          # ./modules/spicetify/default.nix
        ];
      };
    };
  };
}

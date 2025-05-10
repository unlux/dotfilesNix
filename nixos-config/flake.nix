{
  description = "i've spent way too much time on nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
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
    sops-nix.url = "github:Mic92/sops-nix";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # flake-compat = {
    #   type = "github";
    #   owner = "edolstra";
    #   repo = "flake-compat";
    #   flake = false;
    # };
    # prismlauncher = {
    #   url = "github:Diegiwg/PrismLauncher-Cracked";
    #   inputs = {
    #     flake-compat.follows = "flake-compat";
    #     nixpkgs.follows = "nixpkgs";
    #   };
    # };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixos-hardware,
    home-manager,
    # spicetify-nix,
    ghostty,
    disko,
    nix-alien,
    stylix,
    determinate,
    sops-nix,
    zen-browser,
    ...
  }: let
    inherit (self) outputs;
    system = "x86_64-linux";
    username = "lux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      leptup = nixpkgs.lib.nixosSystem {
        specialArgs = {
          hostname = "leptup";
          username = "lux";
          inherit inputs outputs pkgs-stable system;
        };
        modules = [
          disko.nixosModules.disko
          stylix.nixosModules.stylix
          determinate.nixosModules.default
          ./hosts/leptup.nix # > Our main nixos configuration file
          ./hosts/disk.nix # disko config file
          {
            _module.args.disks = ["/dev/nvme0n1"];
          }
          {
            environment.systemPackages = [
              ghostty.packages.${system}.default
            ];
          }
          sops-nix.nixosModules.sops
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
        extraSpecialArgs = {
          inherit inputs outputs pkgs pkgs-stable system;
        };
        modules = [
          ./hosts/home.nix
          # stylix.homeManagerModules.stylix
        ];
      };
    };
  };
}

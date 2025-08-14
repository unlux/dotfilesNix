{
  description = "i've spent way too much time on nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hardware.url = "github:nixos/nixos-hardware";

    # disko.url = "github:nix-community/disko";
    # disko.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/thiagokokada/nix-alien
    # nix-alien.url = "github:thiagokokada/nix-alien";
    stylix.url = "github:danth/stylix";
    sops-nix.url = "github:Mic92/sops-nix";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    home-manager,
    # disko,
    stylix,
    determinate,
    sops-nix,
    auto-cpufreq,
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
    inherit (nixpkgs) lib;
  in {
    nixosConfigurations = {
      leptup = nixpkgs.lib.nixosSystem {
        specialArgs = {
          hostname = "leptup";
          username = "lux";
          inherit inputs outputs pkgs-stable system;
        };
        modules = [
          ./hosts/leptup.nix # > Our main nixos configuration file
          #disko.nixosModules.disko
          #./hosts/disk.nix # disko config file
          # {
          #   _module.args.disks = ["/dev/nvme0n1"];
          # }
          stylix.nixosModules.stylix
          determinate.nixosModules.default
          sops-nix.nixosModules.sops
          auto-cpufreq.nixosModules.default
        ];
      };

      # pc = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   specialArgs = {
      #     hostname = "pc";
      #     username = "lux";
      #     inherit inputs outputs pkgs-stable system;
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

    nixosModules = {
      nvidia = import ./modules/easyNvidia;
    };
  };
}

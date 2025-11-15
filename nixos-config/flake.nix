{
  description = "i've spent way too much time on nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/thiagokokada/nix-alien
    # nix-alien.url = "github:thiagokokada/nix-alien";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    auto-cpufreq.url = "github:AdnanHodzic/auto-cpufreq";
    auto-cpufreq.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    claude-code.url = "github:sadjow/claude-code-nix";
    claude-code.inputs.nixpkgs.follows = "nixpkgs";
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
    disko,
    stylix,
    determinate,
    sops-nix,
    # auto-cpufreq,
    ...
  }: let
    inherit (self) outputs;
    system = "x86_64-linux";
    username = "lux";

    # Centralized pkgs instantiation for both NixOS and home-manager
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        # Workaround for https://github.com/nix-community/home-manager/issues/2942
        allowUnfreePredicate = _: true;
      };
      overlays = [
        # Workaround for broken qgnomeplatform in unstable (issue #449595)
        (final: prev: {
          qgnomeplatform-qt6 = prev.emptyDirectory;
        })
      ];
    };

    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };

    inherit (nixpkgs) lib;
  in {
    nixosConfigurations = {
      leptup = nixpkgs.lib.nixosSystem {
        specialArgs = {
          hostname = "leptup";
          username = "lux";
          inherit inputs outputs pkgs pkgs-stable system;
        };
        modules = [
          ./hosts/leptup.nix # > Our main nixos configuration file
          disko.nixosModules.disko
          ./hosts/disk.nix # disko config file
          {
            _module.args.disks = ["/dev/nvme0n1"];
            nixpkgs.hostPlatform = system;
          }
          stylix.nixosModules.stylix
          determinate.nixosModules.default
          sops-nix.nixosModules.sops
          # auto-cpufreq.nixosModules.default
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
        pkgs = pkgs;
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

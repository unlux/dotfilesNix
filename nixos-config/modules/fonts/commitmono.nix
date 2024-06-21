{
  description =
    "A flake giving access to my custom CommitMono pkg, outside of nixpkgs.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        defaultPackage = pkgs.symlinkJoin {
          name = "myfonts-v2";
          paths = builtins.attrValues
            self.packages.${system}; # Add font derivation names here
        };

        packages.commitmonolux = pkgs.stdenvNoCC.mkDerivation {
          name = "commitmonolux";
          dontConfigue = true;
          src = pkgs.fetchzip {
            url =
              "https://pub-c61fa06b15d540c689d720a2d0110731.r2.dev/CommitMonoLux_V2V143.zip";
            sha256 = "";
            stripRoot = false;
          };
          installPhase = ''
            mkdir -p $out/share/fonts
            cp -R $src $out/share/fonts/opentype/
          '';
          meta = { description = "lux's custom commitmono fonts"; };
        };
      });
}

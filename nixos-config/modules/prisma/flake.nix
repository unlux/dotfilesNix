{
  inputs.pkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.prisma-utils.url = "github:VanCoding/nix-prisma-utils";

  outputs = {
    pkgs,
    prisma-utils,
    ...
  }: let
    nixpkgs = import pkgs {system = "x86_64-linux";};
    prisma =
      (prisma-utils.lib.prisma-factory {
        inherit nixpkgs;
        prisma-fmt-hash = "sha256-3yL8cqFz6n7HTrdrYYULwgG1SIkbr6IkOYHWD1aZ6Ys="; # just copy these hashes for now, and then change them when nix complains about the mismatch
        query-engine-hash = "sha256-/Ejoz+oD1+SDt55CP/goHtE7NZQOX3rczw6+tX24QmM=";
        libquery-engine-hash = "sha256-11/7aapsj/i+M7oZamlt3lo09mnthFEkhTEC5By+oYg=";
        schema-engine-hash = "sha256-F/dcyGuNEvi+Dyw9k9KctnlLujp4y6uR7HROKMcft2c=";
      })
      .fromNpmLock
      ./package-lock.json; # <--- path to our package-lock.json file that contains the version of prisma-engines
  in {
    devShells.x86_64-linux.default = nixpkgs.mkShell {shellHook = prisma.shellHook;};
  };
}

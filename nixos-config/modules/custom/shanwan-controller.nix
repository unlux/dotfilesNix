{
  pkgs,
  lib,
  config,
  ...
}: let
  xpad-paroj = config.boot.kernelPackages.callPackage ({
    stdenv,
    lib,
    fetchFromGitHub,
    kernel,
  }:
    stdenv.mkDerivation {
      pname = "xpad-paroj";
      version = "0.4-unstable-2025-02-14";

      src = fetchFromGitHub {
        owner = "paroj";
        repo = "xpad";
        rev = "9caad15ba366c26337bfbcf3ee1144a6cc07d9ca";
        hash = "sha256-wl6bZzEzLLc1OTy4EjLwmguTQVaiQgjf6WquYHeUbLg=";
      };

      patches = [./xpad-clear-halt.patch];

      nativeBuildInputs = kernel.moduleBuildDependencies;

      buildPhase = ''
        make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd) modules
      '';

      installPhase = ''
        install -D xpad.ko $out/lib/modules/${kernel.modDirVersion}/extra/xpad.ko
      '';

      meta = {
        description = "Out-of-tree xpad driver with ShanWan controller support";
        homepage = "https://github.com/paroj/xpad";
        license = lib.licenses.gpl2Plus;
      };
    }) {};
in {
  boot.extraModulePackages = [xpad-paroj];
}

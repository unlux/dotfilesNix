{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    # Add any options if needed
  };

  config = {
    fonts.packages = [
      (pkgs.stdenvNoCC.mkDerivation {
        pname = "CommitMonoLux";
        version = "V2V143";

        src = pkgs.fetchzip {
          url = "https://pub-c61fa06b15d540c689d720a2d0110731.r2.dev/CommitMonoLux_V2V143.zip";
          sha256 = "0bamydrw8ch7ffrq0fhx5724g1z1a8b2zy70abx2k2qhmg7v63yp";
          stripRoot = false;
        };

        installPhase = ''
          mkdir -p $out/share/fonts/truetype
          find . -name '*.ttf' -exec cp {} $out/share/fonts/truetype/ \;
        '';

        meta = with lib; {
          description = "Commit Mono Lux Font";
          homepage = "https://pub-c61fa06b15d540c689d720a2d0110731.r2.dev/CommitMonoLux_V2V143.zip";
          license = licenses.unfree;
          platforms = platforms.all;
        };
      })
    ];
  };
}

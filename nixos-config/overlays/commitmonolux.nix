{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "commitmonolux";
  version = "2.0";

  src = pkgs.fetchzip {
    url = "https://pub-c61fa06b15d540c689d720a2d0110731.r2.dev/CommitMonoLux_V2V143.zip"; # Replace with the actual URL
    sha256 = "0000000000000000000000000000000000000000000000000000"; # Replace with the actual SHA256 hash
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/custom
    cp $src $out/share/fonts/truetype/custom/
  '';

  meta = with pkgs.lib; {
    description = "Custom commit mono installation";
    license = licenses.mit;
  };
}

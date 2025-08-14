{pkgs-stable, ...}: {
  # Enable Android Studio
  # https://wiki.nixos.org/wiki/Android#Using_the_Android_SDK
  environment.systemPackages = [
    pkgs-stable.android-studio
    pkgs-stable.android-tools
    pkgs-stable.payload-dumper-go
  ];
  nixpkgs.config.android_sdk.accept_license = true;
}

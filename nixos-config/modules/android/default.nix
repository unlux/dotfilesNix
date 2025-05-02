{pkgs, ...}: {
  # Enable Android Studio
  # https://wiki.nixos.org/wiki/Android#Using_the_Android_SDK
  environment.systemPackages = [
    pkgs.android-studio
    pkgs.android-tools
    pkgs.payload-dumper-go
  ];
  nixpkgs.config.android_sdk.accept_license = true;
  programs.adb.enable = true;
}

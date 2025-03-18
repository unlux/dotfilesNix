{pkgs, ...}: {
  environment.systemPackages = [pkgs.flatpak];
  services.flatpak.enable = true;
}

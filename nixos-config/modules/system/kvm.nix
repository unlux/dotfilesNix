{pkgs, ...}: {
  services.spice-vdagentd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  environment.systemPackages = with pkgs; [
    spice-gtk
    usbredir
  ];
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      #ovmf = {
      #  enable = true;
      #  packages = [(pkgs.unstable.OVMF.override {
      #    secureBoot = true;
      #    tpmSupport = true;
      #  }).fd];
    };
  };
}

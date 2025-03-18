{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.cri-tools # for crictl
    pkgs.busybox # for pstree
  ];
}

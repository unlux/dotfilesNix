{ pkgs, ... }:

{
  environment.systemPackages = (
    with pkgs;
    [
      cri-tools # for crictl
      busybox # for pstree
    ]
  );
}

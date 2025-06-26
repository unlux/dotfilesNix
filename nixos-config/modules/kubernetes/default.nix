{pkgs, ...}: {
  environment.systemPackages = [
    # kubernetes
    pkgs.cri-tools # for crictl
    pkgs.busybox # for pstree
    pkgs.kubectl
    pkgs.kind
    pkgs.k9s
  ];

  # services.kubernetes = {
  #   roles = [
  #     "master"
  #     "node"
  #   ];
  #   masterAddress = "api.kube";
  #   apiserverAddress = "https://api.kube:6443";
  #   easyCerts = true;
  #   apiserver = {
  #     securePort = 6443;
  #     advertiseAddress = "10.0.0.5";
  #   };
  # };
}

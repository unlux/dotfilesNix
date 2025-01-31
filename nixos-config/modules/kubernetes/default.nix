{pkgs, ...}: {
  # Include the Kubernetes packages you need
  environment.systemPackages = with pkgs; [
    # kubernetes
    kubectl
  ];

  services.kubernetes = {
    roles = [
      "master"
      "node"
    ];
    masterAddress = "api.kube";
    apiserverAddress = "https://api.kube:6443";
    easyCerts = true;
    apiserver = {
      securePort = 6443;
      advertiseAddress = "10.0.0.5";
    };
  };
}

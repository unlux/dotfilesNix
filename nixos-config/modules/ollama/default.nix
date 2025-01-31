{...}: {
  # services = {
  #   ollama = {
  #     enable = true;
  #     acceleration = "cuda";
  #   };
  # };
  services.open-webui.enable = true;
  # environment.systemPackages = [   #using docker rn
  #   pkgs.ollama-cuda
  # ];
}

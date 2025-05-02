{pkgs, ...}: {
  services = {
    ollama = {
      enable = true;
      acceleration = "cuda";
    };
  };
  services.open-webui = {
    enable = true;
    environment = {
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
      # Disable authentication
      WEBUI_AUTH = "False";
    };
  };
  environment.systemPackages = [
    #using docker rn
    pkgs.ollama-cuda
  ];
}

{
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = true; # disable (i enabled it) password login
    };
    # openFirewall = true;
  };
}

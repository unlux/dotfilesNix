{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gobuster
    # seclists
    netcat-openbsd
    ethtool
    iftop # network monitoring
    ltrace # library call monitoring
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    dnsutils # `dig` + `nslookup`
    iperf3
    ipcalc # it is a calculator for the IPv4/v6 addresses
    ldns # replacement of `dig`
    mtr # A network diagnostic tool
    socat # replacement of openbsd-netcat
    wireshark
  ];
}

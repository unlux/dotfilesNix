{ config, pkgs, ... }:

{
  environment.systemPackages = (with pkgs; [
    # Editors
    neovim
    # zed-editor

    # browesers
    floorp

    # Virtualisation tools
    # unstable.looking-glass-client
    virt-manager

    # Home manager and office tools
    home-manager
    libreoffice-fresh
    qdirstat

    # Language chains
    cargo
    lua
    nodejs_22	
    nodePackages.pnpm
    python3
    rustup
    # electron_28

    # Terminal utilities
    atuin
    auto-cpufreq
    bat
    eza
    fd
    fastfetch
    ffmpeg
    #devbox
    fzf
    gnumake
    inetutils
    lshw
    mpv
    pciutils
    rsync
    starship
    tldr
    tmux
    tree
    usbutils
    wezterm
    wget
    xdg-utils
    yadm
    zoxide

    # Cybersecurity tools
    iptables
    nmap
    netcat-openbsd
    ethtool
    iftop # network monitoring
    ltrace # library call monitoring

    # Shell
    oh-my-zsh

    # Development tools
    gcc
    git
    ntfs3g
    openrgb
    piper

    # Nix related
    nix-output-monitor
    nh
    nvd
    # it provides the command `nom` works just like `nix`
    # with more details log output

    # Productivity tools
    glow # markdown previewer in terminal
    hugo # static site generator

    # System monitoring tools
    btop  # replacement of htop/nmon
    iotop # io monitoring
    lm_sensors # for `sensors` command
    lsof # list open files
    strace # system call monitoring
    sysstat

    # Archive tools
    p7zip
    unzip
    zip

    # Utility tools
    jq # A lightweight and flexible command-line JSON processor
    ripgrep # recursively searches directories for a regex pattern
    yq-go # yaml processor https://github.com/mikefarah/yq

    # Networking tools
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    dnsutils  # `dig` + `nslookup`
    iperf3
    ipcalc  # it is a calculator for the IPv4/v6 addresses
    ldns # replacement of `dig`, it provide the  environment.systemPackages = with pkgs; 
    mtr # A network diagnostic tool
    nmap # A utility for network discovery and security auditing
    socat # replacement of openbsd-netcat

    # Miscellaneous tools
    cowsay
    file
    gawk
    gnupg
    gnused
    gnutar
    nnn # terminal file manager
    tree
    zstd
    wl-clipboard  
      looking-glass-client
      vscode
    
  ]);
}

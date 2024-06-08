{ config, lib, pkgs, pkgs-stable, ... }:

{
  imports = [
    ./nix-helper.nix
    ./cyber.nix
    ../networking/tailscale.nix
    ../cloudflare-warp/warp.nix
    ../docker/dockerRootless.nix
    ../flatpak/flatpak.nix
    

  ];

  environment.systemPackages = (with pkgs; [
    # Editors
      neovim
    # zed-editor
    
    # browsers
      floorp

    # Virtualisation tools
      virt-manager

      home-manager    

    # Language chains
      cargo
      lua
      python3
      # rustup
      gcc

    # Terminal utilities
      auto-cpufreq
      bat
      eza
      fd
      fastfetch
      ffmpeg
      #devbox
      fzf
      gnumake
      mpv
      rsync
      # starship
      tldr
      tmux
      wezterm
      wget
      yadm
      zoxide

    # utils
      lshw
      inetutils
      pciutils
      usbutils
      xdg-utils

    # Archive tools
      p7zip
      unzip
      zip

    # Miscellaneous tools
      git
      ntfs3g
      ripgrep # recursively searches directories for a regex pattern
      cowsay
      file
      gawk
      gnupg
      gnused
      gnutar
      nnn # terminal file manager
      tree
      # zstd
      wl-clipboard  
      appimage-run
      distrobox

    # System monitoring tools
      btop  # replacement of htop/nmon
      iotop # io monitoring
      # lm_sensors # for `sensors` command
      # lsof # list open files
      # strace # system call monitoring
      # sysstat

      # jq # A lightweight and flexible command-line JSON processor
      # yq-go # yaml processor https://github.com/mikefarah/yq

      # glow # markdown previewer in terminal
      # hugo # static site generator


  ]);
}

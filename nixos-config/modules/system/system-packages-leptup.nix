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
      virt-manager
      home-manager    

    # Language chains
      cargo
      lua
      python3
      # rustup
      gcc

    # Terminal utilities
      oh-my-posh
      auto-cpufreq
      bat
      eza
      fd
      fastfetch
      ffmpeg
      #devbox
      fzf
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
      gnumake
      gnutar
      nnn # terminal file manager
      tree
      # zstd
      appimage-run
      distrobox

    # System monitoring tools
      btop  # replacement of htop/nmon
      iotop # io monitoring
      # lm_sensors # for `sensors` command
      # lsof # list open files
      # strace # system call monitoring
      # sysstat

      jq # A lightweight and flexible command-line JSON processor
      # yq-go # yaml processor https://github.com/mikefarah/yq

      # glow # markdown previewer in terminal
      # hugo # static site generator

  ]) ++ (with pkgs-stable; [
    # floorp
  ]);

  environment.variables = {
    # vscode
    NIXOS_OZONE_WL=1;
    # MOZ_ENABLE_WAYLAND = "1";
  };

  services.hardware.openrgb.enable = true;
  services.ratbagd.enable = true;
}

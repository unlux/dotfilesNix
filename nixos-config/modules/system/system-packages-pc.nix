{ config, lib, pkgs, pkgs-stable, ... }:

{
  imports = [
    ../networking/tailscale.nix
    ../cloudflare-warp/warp.nix
    ../docker/dockerrootless.nix
    ../flatpak/flatpak.nix
    

  ];

  environment.systempackages = (with pkgs; [
      neovim
      wezterm

  ]) ++ (with pkgs-stable; [

    floorp
      virt-manager
      home-manager    
      cargo
      lua
      python3
      gcc
      bat
      fastfetch
      ffmpeg
      fzf
      gnumake
      mpv
      rsync
      tmux
      wget
      yadm
      zoxide

    # utils
      lshw
      inetutils
      pciutils
      usbutils
      xdg-utils

    # archive tools
      p7zip
      unzip
      zip

    # miscellaneous tools
      git
      ntfs3g
      ripgrep # recursively searches directories for a regex pattern
      cowsay
      file
      gawk
      gnupg
      gnused
      gnutar
      tree
      appimage-run
      distrobox

    # system monitoring tools
      btop  # replacement of htop/nmon
      iotop # io monitoring
  ]) ;
}


{ pkgs, pkgs-stable, ... }:

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

      microsoft-edge
      chromium
      # virt-manager
      home-manager    
      python3
      gcc
      bat
      fastfetch
      fzf
      gnumake
      mpv
      rsync
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

    # system monitoring tools
      btop  # replacement of htop/nmon
      iotop # io monitoring
  ]) ;
}


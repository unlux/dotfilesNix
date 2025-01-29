# ~/.config/nushell/aliases.nu

# ===== System =====
# alias shutdown = { shutdown now }
# alias reboot = { reboot now }

# ==== Fixed Complex Commands ====
def codehere [] {
    code .
    exit
}

# ===== Misc =====
alias zshconf = nvim ~/.zshrc  # Consider changing to config.nu path
alias aliases = nvim ~/.config/nushell/aliases.nu

# ===== Exa Replacements =====
# Note: Nu has built-in ls, but we'll wrap exa with --ignore-aliases
alias la = ls -a   
alias ll = ls -l   
alias lt = ls -a
alias l. = ls -ald  

# Directory navigation using defs for multiple dots
def --env ".." [] { cd .. }
def --env "..." [] { cd ../.. }
def --env "...." [] { cd ../../.. }
def --env "......" [] { cd ../../../../.. }

# Journalctl
alias jctl = journalctl -p 3 -xb

# ===== NixOS =====
module nix {
    export alias rebuildpls = sudo nixos-rebuild switch --flake ~/nixos-config/
    export alias testpls = sudo nixos-rebuild test --flake ~/nixos-config/
    export alias updatepls = sudo nix-channel --update
    export alias joorserebuildpls = sudo nixos-rebuild switch --flake ~/nixos-config/ --show-trace --print-build-logs --verbose

    # nh aliases
    const FLAKEREF = "nixos-config/"
    export alias nhrebuild = nh os boot $FLAKEREF
    export alias nhrebuildnow = nh os switch $FLAKEREF
    export alias nhtest = nh os test $FLAKEREF
    export alias nhleptup = nh os boot $FLAKEREF -H leptup
    export alias nhleptupnow = nh os switch $FLAKEREF -H leptup
    export alias nhleptuptest = nh os test $FLAKEREF -H leptup
    export alias nhpc = nh os boot $FLAKEREF -H pc
    export alias nhpcnow = nh os switch $FLAKEREF -H pc
    export alias nhpctest = nh os test $FLAKEREF -H pc
}

use nix *

# ===== Other System =====
# alias llogin = bash ~/Documents/LPU-Wireless-Autologin/main.sh
# alias zoho-meeting = appimage-run ~/Documents/Appimages/ZohoMeeting-x64.AppImage
alias nv-smi = ^watch -n 1 nvidia-smi
def editnix [] {
    cd ~/nixos-config
    codehere
}
alias iwdrestart = sudo systemctl restart iwd
alias cls = clear

# ===== Web Dev =====
alias bund = bun dev


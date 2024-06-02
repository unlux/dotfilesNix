{ config, pkgs, ... }:

{
    environment.systemPackages  = with pkgs; [
        gobuster
        seclists
    ];
}
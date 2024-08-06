{ config, pkgs, username, ... }:

{
    environment.systemPackages = with pkgs; [
        tailscale
    ];
    
    services.tailscale = {
        enable = false;
        extraUpFlags = [
        "--shields-up"
        "--operator=${username}"
        ];
    };
}

{ config, pkgs, username, ... }:

{
    environment.systemPackages = with pkgs; [
        tailscale
    ];
    
    services.tailscale = {
        enable = true;
        extraUpFlags = [
        "--shields-up"
        "--operator=${username}"
        ];
    };
}

# {
#     services.tailscale = {
#         enable = true;
#     };
# }

{ config, lib, pkgs, ... }:

with lib;

let

    cfg = config.services.tailscale;

in

{
    options.services.tailscale = {
        enable = mkEnableOption "tailscale";
    };

    config = mkIf cfg.enable {
        # Your tailscale configuration goes here
        # For example, you can add tailscale to the systemPackages list when this option is enabled:
        home.packages = [ pkgs.tailscale ];
    };
}
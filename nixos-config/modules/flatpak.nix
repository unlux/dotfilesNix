# # { confid, pkgs, ...}:

# # {
# #     services.flatpak.enable = true;
# # }

# { config, lib, pkgs, ... }:

# with lib;

# let

#     cfg = config.services.flatpak;

# in

# {
#     options.services.flatpak = {
#         enable = mkEnableOption "flatpak";
#     };

#     config = mkIf cfg.enable {
#         # Your flatpak configuration goes here
#         # For example, you can add flatpak to the systemPackages list when this option is enabled:
#         home.packages = [ pkgs.flatpak ];
#     };
# }

{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        flatpak
    ];
}
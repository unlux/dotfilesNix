# { config, pkgs, ... }:

# {
#     programs.adb.enable = true;
# }


# homemanager syntax

{ config, lib, pkgs, ... }:

with lib;

let

    cfg = config.programs.adb;

in

{
    options.programs.adb = {
        enable = mkEnableOption "adb";
    };

    config = mkIf cfg.enable {
        # Your adb configuration goes here
        # For example, you can add adb to the systemPackages list when this option is enabled:
        home.packages = [ pkgs.android-tools ];
    };
}
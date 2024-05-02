{ config, pkgs, ... }:

{
    programs = {
        git = {
            enable = true;
            userName = "lakshay choudhary";
            userEmail = "lakshaychoudhary77712@gmail.com";
        };
    };
}
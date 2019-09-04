{ config, pkgs, ... }:

{
    networking.hostName = "Meiko";
    services = {
        xserver = {
            videoDrivers = [ "intel" ];
            wacom.enable = true;
        };
    };
    
    environment.systemPackages = with pkgs; [
        libwacom
        blueman
    ];

    hardware.bluetooth = {
        enable = true;
    };
}

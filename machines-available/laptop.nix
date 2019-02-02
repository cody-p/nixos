{ config, pkgs, ... }:

{
    networking.hostName = "Meiko";
    services = {
        xserver = {
            videoDrivers = [ "intel" ];
        };
    };
}

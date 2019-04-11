to use it, create configuration.nix with the following:

{ config, pkgs, ... }:

{
    imports =
    [
        ./hardware-configuration.nix # hardware-scan, do not modify.
        ./machines/common.nix
        # Put the file of the specific machine you're using here.
    ];
}


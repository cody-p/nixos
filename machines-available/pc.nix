{ config, pkgs, ... }:

{
    networking.hostName = "Yuuko";
    
    services = {
        xserver = {
            videoDrivers = [ "nvidia" ];
        };
        openssh = {
            enable = false;
            allowSFTP = true;
            passwordAuthentication = false;
            permitRootLogin = "no";
            ports = [
                4292
            ];
        };
    };
    
    boot = {
        initrd.kernelModules = [
            "nvidia"
            "nvidia_modeset"
            "nvidia_uvm"
            "nvidia_drm"
        ];
    };
    
    environment.systemPackages = with pkgs; [
        krita
        steam
        rustup
        gcc
    ];
    
    fileSystems."/storage" =
    { device = "/dev/disk/by-label/storage";
        fsType = "ext4";
    };
    
    fileSystems."/backup" = {
        device = "/dev/disk/by-label/backup";
        options = [
            "nofail"
        ];
    };
    
    hardware = {
        cpu.intel.updateMicrocode = true;
        nvidia.modesetting.enable = true;
        opengl = {
            driSupport32Bit = true;
            extraPackages = [ pkgs.linuxPackages.nvidia_x11.out ];
        };
    };
}

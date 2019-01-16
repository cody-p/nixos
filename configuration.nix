{ config, pkgs, ... }:

{
    imports =
    [
        ./hardware-configuration.nix # hardware-scan, do not modify.
        ./machines-enabled
    ];

    boot = {
        loader = { 
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };
    };
    
    i18n = {
       consoleKeyMap = "us";
       defaultLocale = "en_US.UTF-8";
    };

    networking = {
        nameservers = [ "8.8.8.8" ];
        networkmanager = {
            enable = true;
        };
    };
    
    time.timeZone = "America/Los_Angeles";
    nixpkgs.config.allowUnfree = true;

    environment = {
        systemPackages = with pkgs; [
            firefox
            thunderbird
            pasystray
            pavucontrol
            wget
            git
            tint2 
            compton
            nano
            sudo
            pciutils
            neofetch
            killall
            keepassx2
            rsync
            glxinfo 
            nitrogen
            gparted
            equilux-theme
            lolcat
            cowsay
            fortune
            gksu
            arandr
            xfce.xfce4-taskmanager
            htop
            tilix
            python
            gnome3.gedit
            libreoffice
            figlet
            qdirstat
        ];
        interactiveShellInit = ''
            neofetch | lolcat
        '';
        variables = {
            EDITOR="gedit";
            TERMINAL="tilix";
        };
    };
    
    programs = {
        dconf.enable = true;
        ssh.askPassword = "";
    };

    sound.enable = true;
    system = {
        autoUpgrade = {
            enable = true;
            channel = https://nixos.org/channels/nixos-unstable;
        };
        #stateVersion = "18.09";
    };
    
    services = {
        dbus.packages = with pkgs; [ 
            xfce.dconf
        ];
        xserver = {
            enable = true;
            layout = "us";
            desktopManager = {
                default = "xfce";
                xterm.enable = false;
                xfce = {
                    enable = true;
                    noDesktop = true;
                    enableXfwm = false;
                };
            };
            libinput = {
                enable = true;
                accelSpeed = "0";
                accelProfile = "flat";
            };
            displayManager = {
                gdm = {
                    wayland = false;
                    enable = true;
                };
            };
            windowManager.i3 = {
                enable = true;
                extraPackages = with pkgs; [
                    dmenu
                    i3lock
                ];
                package = pkgs.i3-gaps;
                configFile = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/cody-p/dotfiles/master/i3/config";
                    sha256 = "6bdc35a96ce9ece7f4b45b429e9ada8b6f208f5418fe22a06a1054e5aa91f414";
                };
            };
        };
    };
    
    hardware = {
        pulseaudio = {
            enable = true;
            support32Bit = true;
        };
    };
    
    users.users = {
        cody = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
        };
        guest = {
            isNormalUser = true;
        };
    };
}

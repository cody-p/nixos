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
            xfce.thunar-archive-plugin
            whois
            xarchiver
            unzip
            galculator
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
        stateVersion = "18.09";
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
                lightdm = {
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
                    sha256 = "e9a40bca02562353fddf3e02522020c6b58e0bbc203c2e8018e4359426d2652a";
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

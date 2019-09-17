{ config, pkgs, ... }:

{
    imports =
    [
        ./hardware-configuration.nix # hardware-scan, do not modify
    ];

    boot = {
        loader = { 
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };
        kernelParams = [ "intel_iommu=on" ];
    };

    i18n = {
       consoleKeyMap = "us";
       defaultLocale = "en_US.UTF-8";
    };

    networking = {
        hostName = "Meiko";
        nameservers = [ 
            "208.67.222.222"
            "208.67.220.220"
            "8.8.8.8"     
        ];
        networkmanager = {
            enable = true;
        };
        
        firewall = {
            enable = true;
            allowedTCPPorts = [ 
                21025 # starbound
            ];
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
            python37Full
            gnome3.gedit
            libreoffice
            figlet
            qdirstat
            xfce.thunar-archive-plugin
            whois
            xarchiver
            unzip
            galculator
            youtube-dl
            mosh
            aseprite
            krita
            evince
            gimp
            deadbeef
            xorg.xmodmap
            xorg.xev
            pa_applet
            tiled
            ntfs3g
	    tor-browser-bundle-bin
            qbittorrent
            appimage-run
            steam
            blender
            mumble
            hdparm
            godot
            ffmpeg
            peek
            virtmanager
            vlc
            OVMF
            blueman
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
        stateVersion = "19.03";
    };
    
    services = {
	#openssh = {
        #    enable = false;
        #    allowSFTP = true;
        #    passwordAuthentication = false;
        #    permitRootLogin = "no";
        #    ports = [
        #        4292
        #    ];
        #};

        qemuGuest.enable = true;
        dbus.packages = with pkgs; [ 
            xfce.dconf
        ];
        xserver = {
            enable = true;
            dpi = 192;
            layout = "us";
            videoDrivers = [ "intel" ];
            #wacom.enable = true;

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
                    sha256 = "d68bb0d6e3330738ff5b03145c16b32f9056ef3036c2ad5739a3563b22828e66";

                };
            };
        };
    };

    virtualisation = {
        libvirtd = {
            enable = true;
            qemuOvmf = true;
        };
    };
    users ={ 
        users = {
            user = {
                isNormalUser = true;
                extraGroups = [ "wheel" "networkmanager" ];
            };
            guest = {
                isNormalUser = true;
            };
        };
        mutableUsers = true;
    };

    hardware = {
        cpu.intel.updateMicrocode = true;
	pulseaudio = {
            enable = true;
            support32Bit = true;
            package = pkgs.pulseaudioFull;
        };
        nvidiaOptimus.disable = true;

        opengl = {
            driSupport32Bit = true;
            extraPackages = [ pkgs.linuxPackages.nvidia_x11.out ];
        };

	enableAllFirmware = true;
	bluetooth = {
        	enable = true;
        };
    };

    powerManagement.cpuFreqGovernor = "ondemand";
}


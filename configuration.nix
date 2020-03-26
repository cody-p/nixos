{ config, pkgs, ... }:

{
	imports =
	[
		./hardware-configuration.nix # hardware-scan, do not modify
	];

	#fileSystems."/storage" = {
	#	device = "/dev/disk/by-uuid/ca3a963f-dc56-4c4c-9d99-3ec7b057fbac";
	#	fsType = "btrfs";
	#	options = [ "nofail" ];
	#};
	
	fileSystems."/backup" = {
		device = "/dev/disk/by-uuid/6676b843-04f7-4c37-a9c0-c571af01cec8";
		fsType = "ext4";
		options = [ "nofail" ];
	};
	
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
	
	time = {
		timeZone = "America/Los_Angeles";
		hardwareClockInLocalTime = true;
	};
	
	nixpkgs.config.allowUnfree = true;

	environment = {
		systemPackages = with pkgs; [
			firefox
			thunderbird
			pasystray
			pavucontrol
			wget
			git
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
			lolcat
			cowsay
			fortune
			arandr
			htop
			tilix
			python37Full
			libreoffice
			figlet
			qdirstat
			whois
			xarchiver
			unzip
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
			hdparm
			godot
			ffmpeg
			peek
			virtmanager
			vlc
			OVMF
			obs-studio
			spotify
			cargo
			gitg
			discord
			vscode
			wine
			unrar
			keepassxc
			btrfsProgs
			p7zip
			zoom-us
			compton
			mumble
			teamviewer

			#kde packages
			#kate
			#kdesu
			#ksuperkey

			#xfce packages
			xfce4-14.xfce4-panel
			xfce4-14.xfce4-settings
			xfce4-14.xfce4-whiskermenu-plugin
			xfce4-14.xfce4-taskmanager
			xfce4-14.thunar
			xfce4-14.xfce4-clipman-plugin
			xfce4-14.xfce4-notifyd
			redshift
			gksu
			galculator
			
			#gnome packages
			#gnome3.gedit
			#gnome3.gnome-tweak-tool
			#gnomeExtensions.dash-to-panel
			#gnomeExtensions.appindicator
			#gedit
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
		stateVersion = "19.09";
	};
	
	services = {
		blueman.enable = true;
		localtime.enable = true;
		logind = {
			lidSwitch = "lock";
			lidSwitchDocked = "ignore";
			lidSwitchExternalPower = "lock";
		};
	#openssh = {
		#	enable = false;
		#	allowSFTP = true;
		#	passwordAuthentication = false;
		#	permitRootLogin = "no";
		#	ports = [
		#		4292
		#	];
		#};

		qemuGuest.enable = true;
		dbus.packages = with pkgs; [ 
			xfce.dconf
		];
		xserver = {
			enable = true;
			exportConfiguration = true;
			#dpi = 192;
			layout = "us";
			videoDrivers = [ "nvidia" ];
			#wacom.enable = true;

			desktopManager = {
				#default = "xfce";
				xterm.enable = false;
				xfce4-14 = {
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
				configFile = "/home/user/dotfiles/i3/main";
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
		steam-hardware.enable = true;
		cpu.intel.updateMicrocode = true;
	pulseaudio = {
			enable = true;
			support32Bit = true;
			package = pkgs.pulseaudioFull;
		};
		nvidia = {
			modesetting.enable = true;
			optimus_prime = {
				enable = true;
				intelBusId = "PCI:0:2:0";
				nvidiaBusId = "PCI:1:0:0";
			};
		};

		opengl = {
			driSupport32Bit = true;
			extraPackages = [ pkgs.linuxPackages.nvidia_x11.out ];
		};

	enableAllFirmware = true;
	bluetooth = {
			enable = true;
			package = pkgs.bluezFull;
		};
	};

	powerManagement.cpuFreqGovernor = "ondemand";
}


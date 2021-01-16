{ config, pkgs, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager.git";
    #rev = "dd94a849df69fe62fe2cb23a74c2b9330f1189ed"; # CHANGEME 
    ref = "release-20.09";
  };
in
{
	imports =
	[	./hardware-configuration.nix
		(import "${home-manager}/nixos")
	];
	
	home-manager.users.user = {
		programs = {
			home-manager.enable = true;
			git = {
			    enable = true;
			    userName = "kt-void";
			    userEmail = "professional@voidlurker.net";
			};
	    	};
    	};
    	
	boot =
	{	loader =
		{ 	grub = {
				enable = true; 
				devices = [ "nodev" ];
				efiSupport = true;
				useOSProber = true;
			};
			efi = {
				canTouchEfiVariables = true;
				efiSysMountPoint = "/boot";
			};
		};
		kernelParams = [ "intel_iommu=on" ];
		kernelModules = [ "kvm-intel" ];
		extraModprobeConfig = "options bbswitch load_state=-1 unload_state=1 nvidia-drm";
	};

	console.keyMap = "us";
	
	environment =
	{	systemPackages = with pkgs;
		[	#things that gnome doesn't need i think
			#arandr	compton	nitrogen pasystray pavucontrol redshift
			#xscreensaver xwinwrap gnome3.file-roller
			#gnome3.gedit gnome3.gnome-tweak-tool pa_applet evince xarchiver
			
			OVMF appimage-run aseprite blender btrfsProgs cargo cowsay deadbeef discord ffmpeg figlet fortune gimp git gitg gksu glxinfo  gparted hdparm htop insync keepassx2 killall krita libreoffice lolcat mkpasswd mosh mpv mumble nano neofetch ntfs3g obs-studio p7zip pciutils peek  qbittorrent qdirstat rsync sl spotify steam sudo thunderbird tiled tilix unrar unzip virtmanager vlc vscode wget whois wine xorg.xev youtube-dl zoom-us google-chrome
			
			gnomeExtensions.appindicator gnomeExtensions.paperwm
			python38 python38Packages.discordpy
			
		];
		interactiveShellInit = ''neofetch | lolcat'';
		variables =
		{	EDITOR="gedit";
			TERMINAL="tilix";
		};
	};
	
	hardware =
	{	steam-hardware.enable = true;
		enableAllFirmware = true;
		cpu.intel.updateMicrocode = true;
		video.hidpi.enable = true;
		pulseaudio =
		{	enable = true;
			support32Bit = true;
			package = pkgs.pulseaudioFull;
		};
		nvidia =
		{	modesetting.enable = true;
			prime =
			{	intelBusId = "PCI:0:2:0";
				nvidiaBusId = "PCI:1:0:0";
				sync =
				{	enable = true;
					allowExternalGpu = false;
				};
			};
		};

		opengl =
		{	driSupport32Bit = true;
			extraPackages = [ pkgs.linuxPackages.nvidia_x11.out ];
		};

		bluetooth =
		{	enable = true;
			package = pkgs.bluezFull;
		};
	};
	
	i18n =
	{	defaultLocale = "en_US.UTF-8";
		supportedLocales = [ "en_US.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8" ];
	};
	
	networking =
	{	hostName = "Meiko";
		hostId = "6d505eb1";
		nameservers = [ "208.67.222.222" "208.67.220.220" "8.8.8.8" ];
		networkmanager.enable = true;
		firewall =
		{	enable = true;
			allowedTCPPorts =
			[ 	21025 #starbound
			];
		};
	};
	
	nixpkgs.config.allowUnfree = true;
	
	powerManagement.cpuFreqGovernor = "ondemand";
	
	programs =
	{	dconf.enable = true;
		ssh.askPassword = "";
	};
	
	services =
	{	blueman.enable = true;
		localtime.enable = true;
		hardware.bolt.enable=true;
		logind =
		{	lidSwitch = "lock";
			lidSwitchDocked = "ignore";
			lidSwitchExternalPower = "lock";
		};
		qemuGuest.enable = true;
		xserver =
		{	enable = true;
			exportConfiguration = true;
			dpi = 192;
			layout = "us";
			videoDrivers = [ "nvidia" ];
			desktopManager =
			{	xterm.enable = false;
				gnome3.enable = true;
			};

			libinput =
			{	enable = true;
				accelSpeed = "0";
				accelProfile = "flat";
			};
			displayManager.lightdm.enable = true;
		};
	};

	sound.enable = true;
	
	system = {
		autoUpgrade.channel = "https://nixos.org/channels/nix-latest";
	};
	
	time =
	{	timeZone = "America/Los_Angeles";
		hardwareClockInLocalTime = true;
	};
	
	users =
	{	users =
		{	user =
			{	isNormalUser = true;
				home = "/home/user";
				extraGroups = [ "wheel" "networkmanager" "kvm" "input" ];
				hashedPassword = "$6$ykg2p//EnCnp$H5I.fVnf45tEiuWqa0p5nnqBFquJfTR.Mg7pb2VnzBicG3HiNe427WiTAwtGXqzOJtI9RfpRQiNoQKlJ34eOa/";
			};
			guest.isNormalUser = true;
		};
		mutableUsers = false;
	};
	
	virtualisation.libvirtd =
	{	enable = true;
		qemuOvmf = true;
		qemuRunAsRoot = false;
		onBoot = "ignore";
		onShutdown = "shutdown";
	};
}


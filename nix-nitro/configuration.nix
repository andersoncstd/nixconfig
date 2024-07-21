# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./services.nix # Server related things (apache, mysql, etc)
    ./game.nix
  ];

  # BOOT COM GRUB
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "nixos";
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.

    # Firewall configuration.
    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        # KDE Connect
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        # KDE Connect
        {
          from = 1714;
          to = 1764;
        }
      ];
      # Syncthing ports: 
      # 8384 for remote access to GUI
      # 22000 TCP and/or UDP for sync traffic
      # 21027/UDP for discovery
      allowedTCPPorts = [
        8384 # Syncthing GUI
        22000 # Syncthing Sync
        21027 # Syncthing discovery
      ];
      allowedUDPPorts = [
        22000 # Syncthing Sync
        21027 # Syncthing discovery
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  i18n = {
    # Select internationalisation properties.
    defaultLocale = "pt_BR.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
  };

  #Services
  services = {
    # OBS: Server related things are on the services.nix file
    # Here some things related to the configuration of the system
    xserver = {
      videoDrivers = [ "nvidia" ];
      # Enable the X11 windowing system.
      enable = true;

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      # Configure keymap in X11
      xkb.layout = "br";

    };
    # touchpad support
    libinput.enable = true;

    # Flatpak support
    flatpak.enable = true;

    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    # Pipewire configuration
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  #Configure hardware
  hardware = {
    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use. Experimental;
      powerManagement.finegrained = false;

      # Nvidia Open-Source driver
      open = false;

      # Enable the Nvidia settings menu,
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      # Support for hybrid (intel integrated + nvidia) graphics setups
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    pulseaudio.enable = false;

    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;

  security.rtkit.enable = true;

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # hardware aceleration support
  nixpkgs = {
    config = {
      # Driver de Vídeo
      nvidia.acceptLicense = true;
    
      allowUnfree = true;

      # Necessary for some programs like Obsidian
      permittedInsecurePackages =
        lib.optional (pkgs.obsidian.version == "1.4.16") "electron-25.9.0";

      packageOverrides = pkgs: {
        intel-vaapi-driver =
          pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
      };
    };
  };

  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "FantasqueSansMono" ]; }) ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jose = {
    isNormalUser = true;
    description = "jose";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" ];
    #packages = with pkgs; [  ];
  };

  # Experimental NIX configs
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #editor
    neovim
    #system utilities
    nmap
    zip
    rar
    unrar
    fish
    git
    pciutils
    lshw
    bash-completion
    #container staff
    podman
    distrobox
    #GPU chooser
    inputs.envycontrol.packages.x86_64-linux.default
    #programing languages 
    nodejs_18
    #Java
    jdk21 # for minecraft
    #Tools for remote desktop
    remmina

  ];

  environment.gnome.excludePackages = (with pkgs; [ gnome-photos gnome-tour ])
    ++ (with pkgs.gnome; [
      gnome-music
      epiphany # web browser
      geary # email reader
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };

    # Habilitando o fish
    fish = {
      enable = true;
      shellAliases = {
        ls = "exa -lha";
        sstart = "sudo systemctl start";
        srestart = "sudo systemctl restart";
        sstop = "sudo systemctl stop";
        senable = "sudo systemctl enable";
        sdisable = "sudo systemctl disable";

      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable common container config files in /etc/containers
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}

{ config, pkgs, inputs, ... }:

{

  # TODO please change the username & home directory to your own
  home.username = "jose";
  home.homeDirectory = "/home/jose";

  home.packages = with pkgs; [

    #nix-tools
    nixfmt #only necessary for format nix language on vscode (my user case)
    direnv 

    #services / self-host
    syncthing

    #browsers
    google-chrome
    firefox

    #cli-tools
    wget
    bat
    eza
    btop
    procs
    ripgrep

    #containers stuff
    podman 
    distrobox
    
    #dev
    rustc
    nodejs
    cargo
    vscode
    lunarvim

    #media
    ffmpeg
    vlc
    mpv
    stremio
    qbittorrent

    #studies
    foliate
    cozy
    obsidian
    anki-bin
    rnote

    #tools
    appimage-run
    megasync
    uget
    dconf
    #anydesk
    bitwarden

    #communication
    telegram-desktop
    discord

    #office
    freeoffice
    evince
    pdfarranger

    #gnome
    gnome.gnome-terminal
    gnome.dconf-editor
    gnome.gnome-tweaks
    #gnome-extensions
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.gsconnect
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.caffeine
    gnomeExtensions.blur-my-shell
    #gnome-themes
    adw-gtk3

    # of course you have to install this
    neofetch

  ];

  # enable neovim and add numbers on lines 
  programs.neovim = {
    enable = true;
    extraConfig = ''
      set number 
    '';
  };

  #set gtk theme to adw-gtk3-dark
  gtk = {
    enable = true;
    theme = { name = "adw-gtk3-dark"; };
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}

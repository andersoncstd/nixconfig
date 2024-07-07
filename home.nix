{ config, pkgs, inputs, ... }:
let 
  appimage_dir = "/home/jose/Applications";
in {

  # TODO please change the username & home directory to your own
  home.username = "jose";
  home.homeDirectory = "/home/jose";

  home.packages = with pkgs; [
    #nix-tools
    nixfmt # only necessary for format nix language on vscode (my user case)
    #direnv 

    #services / self-host
    syncthing
    syncthingtray

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

    #dev
    rustc
    nodejs
    cargo
    vscode
    lunarvim

    # media
    ffmpeg
    #vlc
    mpv
    stremio
    qbittorrent

    # studies
    #foliate
    #cozy
    obsidian
    #anki-bin
    #rnote

    # tools
    appimage-run
    megasync
    uget
    dconf
    #anydesk
    bitwarden

    #communication
    telegram-desktop
    #discord

    #office
    #freeoffice
    pdfarranger

    #gnome
    gnome.gnome-terminal
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.gsconnect
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.caffeine
    gnomeExtensions.blur-my-shell
    gnomeExtensions.gpu-profile-selector
    adw-gtk3

    # of course you have to install this
    neofetch

  ];

  # enable neovim and add numbers on lines 
  programs = {
    neovim = {
      enable = true;
      extraConfig = ''
        set number 
      '';
    };
    mpv = {
      enable = true;
      config = {
        profile = "gpu-hq";
        vo = "gpu";
      };
    };
    git = {
      enable = true;
      userName = "José Anderson";
      userEmail = "anderson.k1006@gmail.com";
    };
  };

  #set gtk theme to adw-gtk3-dark
  gtk = {
    enable = true;
    theme = { name = "adw-gtk3-dark"; };
  };


  #.desktop entries
  xdg.desktopEntries = {
    only-office = {
      name = "OnlyOffice";
      exec = "appimage-run ${appimage_dir}/only-office/only-office.AppImage";
      icon = "${appimage_dir}/only-office/onlyoffice.png";
      categories = [ "Application" "Office" ];
      mimeType = [ "text/docx" "text/doc" "text/pptx" "text/ppt" "text/xls" "text/xlsx" ];
    };
 };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}

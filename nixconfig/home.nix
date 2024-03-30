{ config, pkgs, inputs, ... }:

{

  # TODO please change the username & home directory to your own
  home.username = "jose";
  home.homeDirectory = "/home/jose";

  home.packages = with pkgs; [

    google-chrome
    vscode
    dconf
    qbittorrent
    obsidian
    anki-bin
    megasync
    rnote
    uget
    telegram-desktop
    mpv
    stremio
    discord
    foliate
    cozy
    freeoffice

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

  ];

  programs.neovim = {
    enable = true;
    extraConfig = ''
      set number 
    '';
  };

  gtk = {
    enable = true;
    theme = { name = "adw-gtk3-dark"; };
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}

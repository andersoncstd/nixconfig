{ config, pkgs, inputs, ... }:
let
  appimage_dir = "/home/jose/Applications";
  autoStartPrograms = [ pkgs.megasync pkgs.syncthingtray ];
in {

  home.username = "jose";
  home.homeDirectory = "/home/jose";

  home.packages = with pkgs; [
    #nix-tools
    nixfmt-classic # only necessary for format nix language on vscode (my user case)
    #direnv 

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
    cargo
    vscode
    lunarvim
    dbeaver-bin # replaces phpmyadmin :(

    # media
    ffmpeg
    vlc
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
    syncthingtray

    #communication
    telegram-desktop
    discord

    #office
    #freeoffice
    pdfarranger

    #gnome
    gnome.gnome-terminal
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnome.gnome-settings-daemon
    #gnome extensions
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.gsconnect
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.caffeine
    gnomeExtensions.blur-my-shell
    gnomeExtensions.gpu-profile-selector
    gnomeExtensions.containers
    gnomeExtensions.appindicator

    #gtk theme
    adw-gtk3

    # of course you have to install this
    neofetch

  ];

  # It's linked to user session, so it has to be in home-manager config
  services = { syncthing.tray.enable = true; };

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
      mimeType = [
        "text/docx"
        "text/doc"
        "text/pptx"
        "text/ppt"
        "text/xls"
        "text/xlsx"
      ];
    };
    # source: https://github.com/Diegiwg/PrismLauncher-Cracked/releases/tag/v8.4.1
    prism-launcher = {
      name = "Prism-Launcher";
      exec = "appimage-run ${appimage_dir}/prism-launcher/PrismLauncher-Linux-x86_64.AppImage";
      icon = "${appimage_dir}/prism-launcher/PrismLauncher-Linux-x86_64.png";
      categories = [ "Application" ];
      mimeType = [ ];
    };
  };

  # Start apps on Gnome startup
  home.file = builtins.listToAttrs (map (pkg: {
    name = ".config/autostart/" + pkg.pname + ".desktop";
    value = if pkg ? desktopItem then {
      # Application has a desktopItem entry.
      # Assume that it was made with makeDesktopEntry, which exposes a
      # text attribute with the contents of the .desktop file
      text = pkg.desktopItem.text;
    } else {
      # Application does *not* have a desktopItem entry. Try to find a
      # matching .desktop name in /share/applications
      source = with builtins;
        let
          appsPath = "${pkg}/share/applications";
          # function to filter out subdirs of /share/applications
          filterFiles = dirContents:
            lib.attrsets.filterAttrs
            (_: fileType: elem fileType [ "regular" "symlink" ]) dirContents;
        in (
          # if there's a desktop file by the app's pname, use that
          if (pathExists "${appsPath}/${pkg.pname}.desktop") then
            "${appsPath}/${pkg.pname}.desktop"
            # if there's not, find the first desktop file in the app's directory and assume that's good enough
          else
            (if pathExists "${appsPath}" then
              "${appsPath}/${
                head (attrNames (filterFiles (readDir "${appsPath}")))
              }"
            else
              throw "no desktop file for app ${pkg.pname}"));
    };
  }) autoStartPrograms);

  home.stateVersion = "24.05"; # Do not touch 
  programs.home-manager.enable = true;
}

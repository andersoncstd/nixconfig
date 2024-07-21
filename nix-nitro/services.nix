{ config, pkgs, inputs, lib, ... }:

{
  # Packages
  environment.systemPackages = with pkgs; [ php php82Packages.composer ];

  #Services
  services = {
    #APACHE
    httpd = {
      enable = true;
      enablePHP = true;
    };

    #MYSQL
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    # Enable CUPS server to print documents.
    printing.enable = true;

    # Enable the OpenSSH daemon.
    openssh.enable = true;

  };

  # ------- DISABLED SERVICES ------- #
  # THIS, is how you disable services in NixOS
  systemd.services.httpd.wantedBy = pkgs.lib.mkForce [ ];
  systemd.services.mysql.wantedBy = pkgs.lib.mkForce [ ];
  # Basically, all programs/users/whatever that need to start some other program/service
  # use the wantedBy statement. So, httpd is wantedBy... let's say the system, so it starts
  # wantedBy = [ system ];
  # When you mkForce [ ], you're basically saying that nothing wants this service to start.
}

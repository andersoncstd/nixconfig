{ config, pkgs, inputs, lib, ... }:

{
  #APACHE
  services.httpd.enable = true;
  services.httpd.enablePHP = true;

  #MYSQL
  services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb;

  environment.systemPackages = with pkgs; [
    php
    php82Packages.composer
  ];
}

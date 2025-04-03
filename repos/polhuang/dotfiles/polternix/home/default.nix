{ config, pkgs, ... }:

{
  home.username = "polhuang";
  home.homeDirectory = "/home/polhuang";
  home.stateVersion = "23.11"; 

  home.packages = [
    pkgs.slack
  ];

  programs.home-manager.enable = true;
}

{ config, pkgs, ... }:

{
  home.username = "pol";
  home.homeDirectory = "/home/pol";
  home.stateVersion = "23.11";

  home.packages = [
    pkgs._1password-gui-beta
    pkgs.activitywatch
    pkgs.google-chrome
    pkgs.protonmail-bridge-gui
    pkgs.protonvpn-gui
    pkgs.slack
    pkgs.whatsapp-for-linux
  ];

  programs.home-manager.enable = true;
}

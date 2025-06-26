{ config, pkgs, ... }:

{
  home.username = "polhuang";
  home.homeDirectory = "/home/polhuang";
  home.stateVersion = "23.11";

  home.packages = [
    pkgs._1password-gui-beta
    pkgs.activitywatch
    pkgs.google-chrome
    pkgs.morewaita-icon-theme
    pkgs.mu
    # pkgs.networkmanagerapplet
    pkgs.protonmail-bridge-gui
    # pkgs.protonvpn-gui
    pkgs.slack
    pkgs.ticktick
    pkgs.winbox
  ];

  programs.home-manager.enable = true;
}

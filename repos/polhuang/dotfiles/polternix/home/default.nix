{ config, pkgs, ... }:

{
  home.username = "pol";
  home.homeDirectory = "/home/pol";
  home.stateVersion = "23.11";

  home.packages = [
    # pkgs._1password-gui-beta # now broken
    pkgs.activitywatch
    pkgs.google-chrome
    pkgs.morewaita-icon-theme
    pkgs.protonmail-bridge-gui
    pkgs.ticktick
    pkgs.winbox
  ];

  programs.home-manager.enable = true;

}

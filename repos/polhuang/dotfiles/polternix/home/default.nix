{ config, pkgs, ... }:

{
  home.username = "pol";
  home.homeDirectory = "/home/pol";
  home.stateVersion = "23.11";

  home.packages = [
    pkgs._1password-gui-beta
    pkgs.google-chrome
    pkgs.protonmail-bridge-gui
    pkgs.protonvpn-gui
    pkgs.slack
    pkgs.whatsapp-for-linux
    pkgs.zoom-us          # must be preceded by export "QT_XCB_GL_INTEGRATION=none"
  ];

 xdg.desktopEntries = {
    Zoom = {
      name = "Zoom Workplace";
      comment = "Zoom Video Conference";
      exec = "env QT_XCB_GL_INTEGRATION=none /nix/store/08ny5is98rbvqc4wsadkax0anhgfja81-zoom-6.3.11.7212/bin/zoom %U";
      icon = "Zoom";
      terminal = false;
      type = "Application";
      categories = [ "Network" "Application" ];
      mimeType = [
        "x-scheme-handler/zoommtg"
        "x-scheme-handler/zoomus"
        "x-scheme-handler/tel"
        "x-scheme-handler/callto"
        "x-scheme-handler/zoomphonecall"
        "x-scheme-handler/zoomphonesms"
        "x-scheme-handler/zoomcontactcentercall"
        "application/x-zoom"
      ];
      settings = {
        "X-KDE-Protocols" = "zoommtg;zoomus;tel;callto;zoomphonecall;zoomphonesms;zoomcontactcentercall;";
        "Name[en_US]" = "Zoom Workplace";
      };
    };
  };
  
  programs.home-manager.enable = true;
}

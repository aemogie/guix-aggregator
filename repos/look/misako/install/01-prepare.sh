loadkeys br-abnt2
guix shell git -- git clone https://codeberg.org/look/saayix
guix shell git -- git clone https://codeberg.org/anemofilia/radix
guix shell git -- git clone https://gitlab.com/nonguix/nonguix
mkdir /root/.config/guix
cp /root/misako/install/channels.scm /root/.config/guix/channels.scm
guix archive --authorize < /root/misako/install/signing-key.pub

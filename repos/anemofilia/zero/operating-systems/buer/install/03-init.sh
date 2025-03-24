herd start cow-store /mnt
export GUILE_LOAD_PATH=/root/radix:/root/zero:/root/zero/home-environments:/root/zero:operating-systems:$GUILE_LOAD_PATH
guix system init /root/zero/operating-systems/buer.scm /mnt

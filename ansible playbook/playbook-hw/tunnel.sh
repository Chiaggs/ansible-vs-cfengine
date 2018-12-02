ip tunnel add gre_tun mode gre local 11.0.0.1 remote 21.0.0.1
ip link set gre_tun up
ip addr add 172.16.1.1/24 dev gre_tun


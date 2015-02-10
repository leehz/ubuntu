###  default dnsmasq for lxc ###


dnsmasq -u lx-dnsmasq --strict-order --bind-interfaces --pid-file=/run/lxc/dnsmasq.pid --conf-file= --listen-address 10.0.3.1 --dhcp-range 10.0.3.2,10.0.3.254 --dhcp-lease-max=253 --dhcp-no-override --except-interface=lo --interface=lxcbr0 --dhcp-leasefile=/var/lib/misc/dnsmasq.lxcbr0.leases --dhcp-authoritative

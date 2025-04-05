TODO:
1) Draw diagram of the scenario-4
2) Fix config on switch-0 to allow 172.20.3.0/24 to the firewall (case ipvlan to ipvlan)
3) Fix config on switch-1 to allow 172.20.13.0/24 to the firewall (case ipvlan to ipvlan)
4) Fix config on switch-1 to allow 172.20.12.0/24 to the firewall (case bridge to ipvlan)
5) Add firewall rule for tcp/22 SSH into firwll-0 - VLAN 11
6) Add firewall rule for tcp/443 HTTPS into firwll-0 - VLAN 21
7) Add firewall rule for tcp/587 SSMTP into firwll-0 - VLAN 31

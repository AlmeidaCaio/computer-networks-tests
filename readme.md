# README (WIP)

This project's proposal is to test many common utilities for network diagnosis. It uses Container Images based on Alpine 3.21.2 available at [Docker Hub](https://hub.docker.com/_/alpine/).

Currently, there are 3 scenarios. The following is an execution example of a scenario through a bash CLI:
  ```
  scenarioVersion=1
  bash main.sh $scenarioVersion
  ```
  disabling firewalls:
  ```
  bash main.sh $scenarioVersion --fw-off
  ```

and for containers' clean removal:
  ```
  bash main.sh $scenarioVersion --clean
  ```

* Below is a table about the custom made container images and its utilities/dependencies:

  |Container Image|Filename|Supposed Device|Dependencies|
  |-|-|-|-|
  |cnt-firewall|firewall.containerfile|Layer 4 Firewall|[iptables](https://git.netfilter.org/iptables/), [tcpdump](https://www.tcpdump.org/)|
  |cnt-router|router.containerfile|Router|[quagga](https://www.nongnu.org/quagga/)|
  |cnt-simple|.containerfile|Lean Network Device||
  |cnt-switch-l3|switch-l3.containerfile|Layer 3 Switch|[arp-scan](https://github.com/royhills/arp-scan), [vlan](https://gitlab.alpinelinux.org/alpine/aports/-/tree/master/main/vlan)|
  |cnt-work-station|work-station.containerfile|Lean Work Station Device|[curl](https://curl.se/)|


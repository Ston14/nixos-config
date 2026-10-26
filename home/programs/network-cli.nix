{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # DNS
    dnsutils
    whois

    # Network diagnostics
    iproute2
    iputils
    traceroute
    mtr

    # Packet capture and analysis
    tcpdump
    wireshark-cli

    # Connectivity testing
    curl
    wget
    netcat-openbsd
    openssl
  ];
}

apt update
apt install iptables-persistent
/usr/sbin/iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p icmp -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -s 224.0.0.0/3 -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -s 169.254.0.0/16 -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -s 172.16.0.0/12 -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -s 192.0.2.0/24 -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -s 192.168.0.0/16 -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -s 10.0.0.0/8 -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -s 0.0.0.0/8 -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -s 240.0.0.0/5 -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -s 127.0.0.0/8 ! -i lo -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
/usr/sbin/iptables -A INPUT -p tcp -m connlimit --connlimit-above 111 -j REJECT --reject-with tcp-reset
/usr/sbin/iptables -A INPUT -p tcp --tcp-flags RST RST -m limit --limit 2/s --limit-burst 2 -j ACCEPT
/usr/sbin/iptables -A INPUT -p tcp --tcp-flags RST RST -j DROP
/usr/sbin/iptables -t mangle -A PREROUTING -f -j DROP
/usr/sbin/iptables -N port-scanning
/usr/sbin/iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN
/usr/sbin/iptables -A port-scanning -j DROP
/usr/sbin/iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set
/usr/sbin/iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP

echo "Firewall configuration successfully applied. If you would like to undo this config, edit the script and replace -A with -D."

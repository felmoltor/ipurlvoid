ipurlvoid
=========

Script to masivelly query to blacklists urlvoid.com or ipvoid.com depending on input.
If the input is an IP address query to ipvoid.com, if the input is a domain name, query to urlvoid.com and also resolves it's IP addresses and query to ipvoid.com.

Output: 
* Green is Good
* Red is Bad

Execution example
-----------------

Video: https://www.youtube.com/watch?v=Vga353we1kU

```
	felmoltor@kali:~/Tools/ipurlvoid$ ./ipurlvoid.sh test.list 

	Inspecting IP address 8.8.8.8...
	8.8.8.8: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	
	
	Ispecting domain google.com
	google.com: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	Inspecting related IP address(es) of domain google.com: 173.194.112.102...
	173.194.112.102: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	Inspecting related IP address(es) of domain google.com: 173.194.112.100...
	173.194.112.100: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	Inspecting related IP address(es) of domain google.com: 173.194.112.103...
	173.194.112.103: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	Inspecting related IP address(es) of domain google.com: 173.194.112.99...
	173.194.112.99: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	Inspecting related IP address(es) of domain google.com: 173.194.112.105...
	173.194.112.105: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	Inspecting related IP address(es) of domain google.com: 173.194.112.110...
	173.194.112.110: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	Inspecting related IP address(es) of domain google.com: 173.194.112.97...
	173.194.112.97: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	Inspecting related IP address(es) of domain google.com: 173.194.112.98...
	173.194.112.98: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	Inspecting related IP address(es) of domain google.com: 173.194.112.104...
	173.194.112.104: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	Inspecting related IP address(es) of domain google.com: 173.194.112.96...
	173.194.112.96: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	Inspecting related IP address(es) of domain google.com: 173.194.112.101...
	173.194.112.101: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	
	
	Inspecting IP address 192.168.1.1...
	192.168.1.1: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	
	
	Inspecting IP address 91.237.88.230...
	91.237.88.230: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	
	
	Inspecting IP address 67.198.207.34...
	67.198.207.34: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	
	
	Inspecting IP address 173.230.133.99...
	173.230.133.99: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	
	
	Ispecting domain bing.com
	bing.com: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	Inspecting related IP address(es) of domain bing.com: 204.79.197.200...
	204.79.197.200: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	
	
	Inspecting IP address 67.210.170.169...
	67.210.170.169: [BLACKLISTED]  (2/37 detected this IP/URL as a threat)
	
	
	Inspecting IP address 204.79.197.200...
	204.79.197.200: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	
	
	Ispecting domain ns.dunno-net.com
	ns.dunno-net.com: [BLACKLISTED]  (4/27 detected this IP/URL as a threat)
	Inspecting related IP address(es) of domain ns.dunno-net.com: 69.43.161.141...
	69.43.161.141: [PROBABLY CLEAN]  (It seems this IP/URL is not a threat)
	
	
	Ispecting domain penchatox.sin-ip.es
	penchatox.sin-ip.es: [BLACKLISTED]  (2/27 detected this IP/URL as a threat)
	Inspecting related IP address(es) of domain penchatox.sin-ip.es: 67.210.170.141...
	67.210.170.141: [BLACKLISTED]  (2/37 detected this IP/URL as a threat)
	
	
	Ispecting domain symconempkr.com
	symconempkr.com: [BLACKLISTED]  (5/27 detected this IP/URL as a threat)
	Inspecting related IP address(es) of domain symconempkr.com: 194.116.174.85...
	194.116.174.85: [BLACKLISTED]  (2/37 detected this IP/URL as a threat)
	
	felmoltor@kali:~/Tools/ipurlvoid$ 

```



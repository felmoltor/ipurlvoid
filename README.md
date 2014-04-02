ipurlvoid
=========

Script to masivelly query to blacklists urlvoid.com or ipvoid.com depending on input.

Output: 
* Green is Good
* Red is Bad

Execution example
-----------------

```
	felmoltor@kali:~/Tools/bulkipvoid$ ./ipurlvoid.sh test.list 
	Asking to ipvoid.com for '8.8.8.8'. Please, wait...
	This is an IP, asking to ipvoid.com
	
	[PROBABLY CLEAN]  It seems this IP/URL is not a threat.
	
	Asking to ipvoid.com for 'google.com'. Please, wait...
	This is not an IP, asking to urlvoid.com
	
	 [PROBABLY CLEAN]  It seems this IP/URL is not a threat.
	
	Asking to ipvoid.com for '192.168.1.1'. Please, wait...
	This is an IP, asking to ipvoid.com
	
	 [PROBABLY CLEAN]  It seems this IP/URL is not a threat.
	
	Asking to ipvoid.com for '91.237.88.230'. Please, wait...
	This is an IP, asking to ipvoid.com
	
	 [PROBABLY CLEAN]  It seems this IP/URL is not a threat.
	
	Asking to ipvoid.com for '67.198.207.34'. Please, wait...
	This is an IP, asking to ipvoid.com
	
	 [PROBABLY CLEAN]  It seems this IP/URL is not a threat.
	
	Asking to ipvoid.com for '173.230.133.99'. Please, wait...
	This is an IP, asking to ipvoid.com
	
	 [PROBABLY CLEAN]  It seems this IP/URL is not a threat.
	
	Asking to ipvoid.com for 'bing.com'. Please, wait...
	This is not an IP, asking to urlvoid.com
	
	 [PROBABLY CLEAN]  It seems this IP/URL is not a threat.
	
	Asking to ipvoid.com for '67.210.170.169'. Please, wait...
	This is an IP, asking to ipvoid.com
	
	 [BLACKLISTED]  2/37 detected this IP/URL as a threat.
	
	Asking to ipvoid.com for '204.79.197.200'. Please, wait...
	This is an IP, asking to ipvoid.com
	
	 [PROBABLY CLEAN]  It seems this IP/URL is not a threat.
	
	Asking to ipvoid.com for 'ns.dunno-net.com'. Please, wait...
	This is not an IP, asking to urlvoid.com
	
	 [BLACKLISTED]  4/25 detected this IP/URL as a threat.
	
	Asking to ipvoid.com for 'penchatox.sin-ip.es'. Please, wait...
	This is not an IP, asking to urlvoid.com
	
	 [BLACKLISTED]  3/25 detected this IP/URL as a threat.
	
	Asking to ipvoid.com for 'symconempkr.com'. Please, wait...
	This is not an IP, asking to urlvoid.com
	
	 [BLACKLISTED]  5/25 detected this IP/URL as a threat.
```



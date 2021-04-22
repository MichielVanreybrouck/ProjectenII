# Testplan taak 1: Ping test
* Check of alle laptops naar elkaar kunnen pingen.
* De laptops kunnen ook naar de printers en de NAS kunnen pingen.
		
### Test resultaat positief
	Pinging 192.168.0.5 with 32 bytes of data:

	Reply from 192.168.0.5: bytes=32 time=31ms TTL=54
	Reply from 192.168.0.5: bytes=32 time=31ms TTL=54
	Reply from 192.168.0.5: bytes=32 time=31ms TTL=54
	Reply from 192.168.0.5: bytes=32 time=31ms TTL=54
	Ping statistics for 192.168.0.5:

	Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),

	 Approximate round trip times in milli-seconds:

		Minimum = 24ms, Maximum = 31ms, Average = 26ms

### Test resultaat negatief
	Pinging 192.168.0.5 with 32 bytes of data:

	Request timed out

	Request timed out

	Request timed out

	Request timed out

	Ping statistics for 192.168.0.5:

	Packets: Sent = 4, Received = 0, Lost = 4 (100% loss)

# Testplan taak 2: VLAN test
* Voeg een extra pc toe en verbind deze met de switch. Probeer vanuit deze pc te pingen naar een van de laptops of printers. 
	
### Test resultaat positief
	C:\ping 192.168.0.5

	Pinging 192.168.0.5 with 32 bytes of data:

	Request timed out.
	Request timed out.
	Request timed out.
	Request timed out.

	Ping statistics for 192.168.0.5:
		Packets: Sent = 4, Received = 0, Lost = 4 (100% loss),

### Test resultaat negatief
	C:\ping 192.168.0.5

	Pinging 192.168.0.5 with 32 bytes of data:
	
	Reply from 192.168.0.5: bytes=32 time=31ms TTL=54
	Reply from 192.168.0.5: bytes=32 time=31ms TTL=54
	Reply from 192.168.0.5: bytes=32 time=31ms TTL=54
	Reply from 192.168.0.5: bytes=32 time=31ms TTL=54
	Ping statistics for 192.168.0.5:

	Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),

	 Approximate round trip times in milli-seconds:

		Minimum = 24ms, Maximum = 31ms, Average = 26ms
		
# Testplan taak 3: VLAN check
* Ga naar de switch en in priviliged exec mode voer je het commando `sh vlan` uit.

### Test resultaat positief
Er is een vlan 10 met naam Bureaus en een vlan 20 met naar Security. De poorten van waar de pc's, de printers en de NAS-server op aan zijn gesloten zitten in vlan 10. 
De poort waar het beveiligingssysteem op aangesloten is zit in vlan 20.

```
1    default 
active    Fa0/7, Fa0/8, Fa0/9, Fa0/10
			Fa0/12, Fa0/13, Fa0/14, Fa0/15
			Fa0/16, Fa0/17, Fa0/18, Fa0/19
			Fa0/20, Fa0/21, Fa0/22, Fa0/23
			Fa0/24, Gig0/1, Gig0/2
10   Bureaus
active    Fa0/1, Fa0/3, Fa0/4, Fa0/5, Fa0/6, Fa0/11
20   Security                         active    Fa0/2
```

### Test resultaat negatief
Mogelijke problemen.

	* Vlan 10 & 20 bestaan niet.
	* De poorten zitten niet in de juiste VLANs.

# Testplan taak 4: Router check
* Ga naar de router en in priviliged exec mode voer je het commando `sh run` uit.
		
### Test resultaat positief
De volgende dingen kunnen teruggevonden worden in de output: 

```
* service password-encryption
* hostname R1
* enable secret 5 $1$mERr$9cTjUIEqNGurQiFU.ZeCi1
* ip dhcp excluded-address 192.168.0.1 192.168.0.115
* ip dhcp pool POOL1
	network 192.168.0.0 255.255.255.0
	default-router 192.168.0.4
	dns-server 192.168.0.2
	domain-name example.com
* interface GigabitEthernet0/0
 description Link to Switch
 ip address 192.168.0.2 255.255.255.0
 duplex auto
 speed auto
* interface GigabitEthernet0/1
 description Link to modem
 ip address 192.168.0.4 255.255.255.0
 duplex auto
 speed auto
 shutdown
* banner motd ^CAuhtorised acces only^C
* line con 0
 password 7 0822455D0A16
 login
* line vty 0 4
 password 7 0822455D0A16
 login
```	
### Test resultaat positief
Als er een stuk van het positief resultaat van hierboven niet overeenkomt met wat jij krijgt dan is er iets fout gegaan tijdens de configuratie.

# Testplan taak 5: Switch check
* Ga naar de switch en in priviliged exec mode voer je het commando `sh run` uit.

### Test resultaat positief
De volgende dingen kunnen teruggevonden worden in de output: 

```
* service password-encryption
* hostname MainSwitch
* enable secret 5 $1$mERr$9cTjUIEqNGurQiFU.ZeCi1
* enable secret 5 $1$mERr$9cTjUIEqNGurQiFU.ZeCi1
* enable password 7 0822455D0A16
* interface FastEthernet0/1
 switchport access vlan 10
 switchport mode access
* interface FastEthernet0/2
 switchport access vlan 20
 switchport mode access
* interface FastEthernet0/3
 switchport access vlan 10
 switchport mode access
* interface FastEthernet0/4
 switchport access vlan 10
 switchport mode access
* interface FastEthernet0/5
 switchport access vlan 10
 switchport mode access
* interface FastEthernet0/6
 switchport access vlan 10
 switchport mode access
* interface FastEthernet0/11
 switchport access vlan 10
 switchport mode access
* interface Vlan1
 ip address 192.168.0.254 255.255.255.0
* ip default-gateway 192.168.0.1
* banner motd ^CAuhtorised acces only^C
* line con 0
 password 7 0822455D0A16
 login
* line vty 0 4
 password 7 0822455D0A16
 login
```

### Test resultaat positief
Als er een stuk van het positief resultaat van hierboven niet overeenkomt met wat jij krijgt dan is er iets fout gegaan tijdens de configuratie.

Auteur(s) testplan: Nick



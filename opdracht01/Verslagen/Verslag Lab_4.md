# Deel 1: Cisco  (wachtwoord exec mode is class)
## PART 1: Set up Network Topology 
             
Stap 1 : In Packet tracer, neem 3 switchen, 3 routers en 3 PC's.

Stap 2 : Verbindt deze apparaten zoals te zien is in het topologisch diagram.

## PART 2: Configure devices en verify connectivity 
     
Stap 1 : We stellen de IP-adressen , subnetmasks en default gateways van de PC's in (volgens gegeven addresserings tabel).
         Dit doen we in packet tracer door naar het tabblad Desktop te gaan en IP configuration te selecteren.
         Vul de juiste ip addressen en subnetmasks in. Vergeet ook de default gateways niet aan te vullen. 
         Het lukt nog niet om te pingen want de routers moeten nog geconfigureerd worden. 

Stap 2 : We zullen nu de routers configureren. Hiervoor clearen we eerst de configuratie van elke router met behulp van de commando's 		_erase startup-config_ en _reload_  (antwoord nee als gevraagd wordt om de veranderingen op te slaan)
	Vervolgens volgt de basic routing configuratie: __hostname__ (instellen naam router) , __no ip domain-lookup__ 
	Merk op dat ik hier geen wachtwoorden instel omdat dat bij de uiteindelijke fysieke opstelling kan leiden tot problemen.

	Voeg de volgende commando's uit op elke router. 
	> R1(config)#line console 0 

	> R1(config-line)#logging synchronous

	> R1(config-line)#line vty 0 4

	> R1(config-line)#logging synchronous
	
	 Toevoegen exec-timeout aan console en vty lines voor elke router
	>R1(config)#line console 0

	>R1(config-line)#exec-timeout 0 0

	>R1(config-line)#line vty 0 4

	>R1(config-line)#exec-timeout 0 0

Stap 3 : Instellen Routes (met extra debug hulp door vooraf __R1#debug ip routing__ in te voeren)

	>R1#configure terminal
	
	>R1(config)#interface fastethernet 0/0
	
	>R1(config-if)#ip address 172.16.3.1 255.255.255.0
	is_up:!0!state:!6!sub!state:!1!line:!1!has_route:!False!   (debug info)
	
	>R1(config-if)#no shutdown
	
	>R1#show ip route                (controle of route nu bestaat)
	
	zelfde commands voor de WAN interface Serial 0/0/0 op een ding na. Voor de no shutdown command nog de clock rate aangeven
	
	>R1(config-if)#clock rate 64000
	
	De WAN moet echter ook eerst op R2  geconfigureerd worden voor de verbinding in de routing table wordt opgenomen.
	
	Als je met debugging werkte gebruik je deze command om ze te beeindigen
	
	>R1(config3if)#end
	>R1#no debug ip routing
	
Stap 4: Instellen Statische Route (Next-Hop manier)
	
	Algemene voorstelling
	>Router(config)#)ip route network-address subnet-mask ip-address

	Vb router 3
	>R3(config)#ip route 172.16.1.0 255.255.255.0 192.168.1.2
	
	Wordt na show ip route weergegeven als   
	>S        172.16.1.0 [1/0] via 192.168.1.2
	
	Tevens voor R2
	>R2(config)#ip route 192.168.2.0 255.255.255.0 192.168.1.1

Stap 5: Instellen Statische Route (met Exit Interface)

	Algemene voorstelling
	>Router(config)#ip route network-address subnet-mask exit-interface
	
	Vb router 3
	>R3(config)#ip route 172.16.2.0 255.255.255.0 Serial0/0/1
	
	Wordt na show ip route weergegeven als   
	>S       172.16.2.0 is directly connected, Serial0/0/1
	
Stap 6: Instellen Default Static Route

	Algemene voorstelling
	>Router(config)#ip route 0.0.0.0 0.0.0.0 { ip-address | interface }
	
	Vb Router 1
	>R1(config)#ip route 0.0.0.0 0.0.0.0 172.16.2.2
	
	Show ip route geeft nu de volgende 2 extra lijnen weer
	>Gateway of last resort is 172.16.2.2 to network 0.0.0.0
	>S*   0.0.0.0/0 [1/0] via 172.16.2.2
	
Stap 7: Instellen Summary Static Route 
	
	Looking at the three networks at the binary level, we can a common boundary at the 22nd bit from the left.
	172.16.1.0 10101100.00010000.00000001.00000000
	172.16.2.0 10101100.00010000.00000010.00000000
	172.16.3.0 10101100.00010000.00000011.00000000
	The prefix portion will include 172.16.0.0, because this would be the prefix if we turned off all the bits to
	the right of the 22nd bit.
	Prefix 172.16.0.0
	To mask the first 22 left-most bits, we use a mask with 22 bits turned on from left to right:
	Bit!Mask 11111111.11111111.11111100.00000000
	This mask, in dotted-decimal format, is...
	Mask 255.255.252.0
	
	Voor router 3 wordt dit dan
	>The network to be used in the summary route is 172.16.0.0/22.
	>R3(config)#ip route 172.16.0.0 255.255.252.0 192.168.1.2
	
	We kunnen hierna de Statische routes uit Stap 4 en 5 verwijderen
	>R3(config)#no ip route 172.16.1.0 255.255.255.0 192.168.1.2
	>R3(config)#no ip route 172.16.2.0 255.255.255.0 Serial0/0/0
	
	R3 now only has one route to any host belonging to networks 172.16.0.0/24, 172.16.1.0/24,
	172.16.2.0/24, and 172.16.3.0/24. Traffic destined for these networks will be sent to R2 at 192.168.1.2
	
	
	
	


## PART 3: Testing network connectivity

Nu kunnen we als alles correct verlopen is de pc's elkaar laten pingen. Dit doen we in packet tracer door voor de betreffende PC naar het tabblad Desktop te gaan en Command Prompt te selecteren. Hierin geef je dan het commando __ping__ in gevolgd door het IP-adres van de PC die je wil pingen. 

Enkele extra commando's om gebruik makende van de router's CLI extra info over diens verbindingen te verkrijgen
	
	>R#show ip route
	>R#show ip interface brief
	>R#show running-config
	 
    
# Deel 2: stappenplan voor fysieke opstelling

    Dit stappenplan komt in zeer grote mate overeen met de cisco opstelling. 
	 


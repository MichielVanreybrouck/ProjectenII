  # Deel 1: Opzetten van de netwerktopologie
  1. 1 Cisco 1941 router, 1 Cisco 2960 Switch en 2 pc's plaatsen
  2. Alle toestellen verbinden zoals op het topologisch diagram.
  
  # Deel 2: Configureer toestellen en verifiëer de connectiviteit
  1. Op de pc's, onder Config->Settings->Gateway/Dns IPv4 stel je de default gateway in.
     Onder Config->FastEthernet0->IP Configuration kan je het IP adres instellen. 
     PC-A kan nog niet naar PC-B pingen
  2. Router Configureren: We gaan eerst de configuratie van de router cleanen. Dit doen we met behulp van de commando's  
     *erase startup-config* en *reload*(nee ingeven als er gevraagt word op de veranderingen op te slaan).
     
     a) Naar Privileged EXEC mode gaan -> *enable*
     
     b) Configuration mode -> *conf t*
     
     c) Naam geven aan de router -> *hostname R1*
     
     d) DNS loockup uitschakelen -> *no ip domain-loockup*
     
     e,f en g heb ik niet geconfigureert omdat die problemen kan geven tijdens het uitvoeren van de configuratie op de fysieke toesellen
     
     h) Wachtwoorden encrypteren -> *service password-encryption*
     
     i) Banner bericht -> *banner motd #Unuathorised access prohibited#
     
     j) Beide interfaces configureren en activeren
	
	> R1(config)#int g0/0
        
	> R1(config-if)#description Connection to S1.
        
	> R1(config-if)#ip address 192.168.1.1 255.255.255.0
        
	> R1(config-if)#no shutdown
        
	> R1(config-if)#exit
        
	> R1(config)#exit
	
      
      k) running config opslaan (deze heb ik niet gedaan omdat dit problemen kan oplevere tijdens het uitvoeren van de configuratie op de fysieke toestellen)
      
      l) Klok instellen -> *clock set 17:00:00 16 Feb 2020
      
      m) PC-B pingen vanaf PC-A -> ping 192.168.0.3

# Deel 3: Reset procedure
Nadat alles gecongigureert en getest is moeten alle toestellen weer naar hun standaard instellingen worden gezet.
  1. Router reset
  
    a) Naar privileged EXEC mode gaan -> *enable*
    
    b) Startup-config verwijderen uit NVRAM -> *erase startup-config*
    
    c) Router reloaden -> *reload*
    
  2. Switch reset
  
    a) Naar privileged EXEC mode gaan -> *enable*
    
    b) vlan.dat verwijdere -> *delete vlan.dat*
    
    c) Startup-config verwijderen uit NVRAM -> *erase startup-config*
    
    d) Switch reloaden -> *reload*

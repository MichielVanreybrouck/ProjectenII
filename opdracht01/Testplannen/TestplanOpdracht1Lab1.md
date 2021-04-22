# Lab 1: Console connectie opzetten tussen switch en PC
##  Testen bij deel 1: Connectie opzetten door seriële console poort switch
----
### Test 1: Connectie verifiëren tussen switch en PC
#### Stappenplan:
- Switch en pc opstarten
- Terminal openen op PC1
> enable
#####  Test resultaat positief:
> Er is een connectie met Switch, we bevinden ons in de user exec mode
----
### Test 2: Versie IOS image en clock verifiëren
#### Stappenplan:
- Switch en pc opstarten
- Terminal openen op PC1
> enable  
> show version  
> show clock  
#####  Test resultaat positief:
> show version toont **SW image** als *C2960-LANBASE-M*

> show clock toont huidige datum en uur

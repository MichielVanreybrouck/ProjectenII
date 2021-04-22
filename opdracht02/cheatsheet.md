# Cheatsheet Vagrant en Docker

| Commando                               | Uitleg        |
| -------------                          | ------------- |
| vagrant up                             | Start de virtuele machine volgense de configuratie        |
| vagrant destroy (-f)                   | Stopt de virtuele configuratie en verwijdert alle bestanden van de VM        |
| vagrant reload                         | Herlaad de virtuele machine en doet provisioning opnieuw. Sneller dan destroy en up maar vaak fouten        |
| vagrant ssh                            | Opent een ssh connectie met de VM via username vagrant |
| docker build | Maakt een image met behulp van een Dockerfile |
| docker container | Manage alle containers die op dit moment actief zijn |
| docker info | Toont informatie over docker, containers en images |
| docker rm | Verwijdert een container |
| docker update | Update docker |
| docker start/stop | Start of stopt een container |
| docker-compose up | Start de composer om meerdere containers samen te verbinden met elkaar |
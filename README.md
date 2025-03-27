# Monitoring-Local

Un script simple pour installer et configurer automatiquement [Netdata](https://learn.netdata.cloud/) sur une distribution **Debian/Ubuntu** (ou dérivés).  
Il installe Netdata en version statique, ouvre le port 19999/tcp pour l’accès web, et vérifie le statut du service.

## Installation rapide

Exécutez les **4 commandes** suivantes :

```bash
sudo apt update && sudo apt install curl -y
curl -O https://raw.githubusercontent.com/oxo140/Monitoring-Local/main/installation.sh
chmod +x installation.sh
sudo ./installation.sh -y

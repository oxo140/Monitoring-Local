# monitoring-Local

Ce dépôt contient un script permettant d’installer et de configurer rapidement Netdata sur un serveur local sous Linux (par exemple Mageia 8). Netdata offre une interface web en temps réel pour surveiller :

- L’utilisation CPU, RAM, disque
- La bande passante réseau
- Les processus
- De nombreuses autres métriques

## 1. Prérequis

- Un système Linux avec **bash** (testé sur Mageia 8, devrait fonctionner sur d’autres distributions).
- Droits **root** ou équivalents (sudo).
- Un accès à **internet** (pour télécharger le script Netdata).

## 2. Installation

1. **Cloner** ce dépôt :
   ```bash
   git clone https://github.com/ton-compte/monitoring-Local.git
   cd monitoring-Local

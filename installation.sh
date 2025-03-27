
---

## Exemple de **script d’installation** : `installation.sh`

> **Remarque** :  
> - Ce script cible **Debian/Ubuntu** (qui utilisent APT).  
> - Il installe Netdata en **version statique** (pour éviter les soucis de dépendances).  
> - Il ouvre le port **19999** via **ufw** s’il est installé, sinon via **iptables**.  

```bash
#!/usr/bin/env bash
#
# installation.sh
# Script d'installation automatique de Netdata (version statique)
# pour Debian/Ubuntu (ou distributions dérivées).
#

set -e  # Quitter en cas d'erreur
set -u  # Erreur si variable non initialisée

# Vérifier si on est root
if [[ $EUID -ne 0 ]]; then
  echo "Merci de lancer ce script en tant que root (ou avec sudo)."
  exit 1
fi

echo "============================================"
echo "   Installation de Netdata (statique)"
echo "============================================"

# 1) Téléchargement du script statique Netdata
echo "[1/4] Téléchargement du script statique Netdata..."
wget -q https://my-netdata.io/kickstart-static64.sh -O netdata-kickstart.sh

# 2) Exécution du script Netdata
echo "[2/4] Exécution du script Netdata..."
bash netdata-kickstart.sh --stable-channel --disable-telemetry

# 3) Ouverture du port 19999
echo "[3/4] Configuration du pare-feu..."
if command -v ufw &>/dev/null; then
  echo "  -> ufw détecté. Ouverture du port 19999/tcp."
  ufw allow 19999/tcp || true
elif command -v iptables &>/dev/null; then
  echo "  -> ufw non installé, utilisation iptables."
  iptables -I INPUT -p tcp --dport 19999 -j ACCEPT
  # Sauvegarde iptables (varie selon la distro)
  if command -v iptables-save &>/dev/null; then
    iptables-save > /etc/iptables.rules
    echo "Les règles iptables sont sauvegardées dans /etc/iptables.rules."
    echo "Pensez à les recharger au démarrage (via rc.local ou autre)."
  fi
else
  echo "  -> Aucun pare-feu détecté, veuillez ouvrir le port 19999 manuellement si nécessaire."
fi

# 4) Vérification du service
echo "[4/4] Vérification du service Netdata..."
systemctl status netdata --no-pager || true

echo "============================================"
echo "     INSTALLATION TERMINEE !"
echo " Accès Web : http://[IP_SERVEUR]:19999"
echo "============================================"

Voici un exemple de structure pour un dépôt GitHub nommé **monitoring-Local**.  
Le dépôt contient :

1. Un fichier **README.md** expliquant le but du projet et comment l’installer.  
2. Un script d’installation automatique (par exemple **install.sh**) qui :
   - Installe Netdata (via le script officiel “kickstart” ou la version statique).  
   - Ouvre le port 19999 dans le pare-feu.  
   - Vérifie le statut du service.  

Tu peux l’adapter selon tes besoins.  

---

# 1. Exemple de `README.md`

```markdown
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
   ```

2. **Rendre le script exécutable** :
   ```bash
   chmod +x install.sh
   ```

3. **Lancer l’installation** :
   ```bash
   sudo ./install.sh
   ```

Le script va :

- Installer Netdata via le script officiel.
- Ouvrir le port **19999/tcp** dans le pare-feu (firewalld ou iptables).
- Vérifier que Netdata est actif.

## 3. Utilisation

Une fois installé, Netdata est disponible à l’adresse suivante :

```
http://[IP-de-ton-serveur]:19999
```

Par défaut, Netdata est démarré et activé au démarrage du système. Tu peux vérifier son statut :

```bash
systemctl status netdata
```

## 4. Personnalisation

Si tu souhaites désactiver ou personnaliser certains collecteurs (MySQL, Docker, etc.), consulte les fichiers de configuration dans :

```
/etc/netdata/
/etc/netdata/conf.d/
/etc/netdata/python.d/
/etc/netdata/go.d/
```

La documentation officielle se trouve ici :  
[Netdata Documentation](https://learn.netdata.cloud/docs)

## 5. Désinstallation

Pour supprimer Netdata et ses fichiers, tu peux soit :

- Supprimer le dossier d’installation /opt/netdata (varie selon la méthode installée),  
- Désinstaller via le gestionnaire de paquets si disponible,  
- Ou suivre la [procédure de désinstallation officielle](https://learn.netdata.cloud/docs/agent/packaging/installer#uninstall).

---

**Bon monitoring !**  
N’hésite pas à créer des issues ou faire des pull-requests pour proposer des améliorations.
```

---

# 2. Exemple de script d’installation : `install.sh`

> **Attention** : À adapter selon ta distribution. Ci-dessous, on vérifie d’abord si **firewalld** est présent ; sinon, on tombe sur iptables. On utilise le script statique de Netdata pour simplifier l’installation.  

```bash
#!/usr/bin/env bash
#
# Script d'installation automatique de Netdata
# Pour Mageia 8 (ou autres distributions) avec pare-feu firewalld ou iptables
#

set -e  # Quitte si une commande échoue
set -u  # Erreur si variable non initialisée

# Vérification qu'on est bien en root (ou sudo)
if [[ $EUID -ne 0 ]]; then
  echo "Merci de lancer ce script en tant que root (ou avec sudo)."
  exit 1
fi

echo "Installation de Netdata (version statique)..."

# 1. Téléchargement du script officiel statique
wget https://my-netdata.io/kickstart-static64.sh -O netdata-kickstart.sh

# 2. Lancement du script
bash netdata-kickstart.sh --stable-channel --disable-telemetry

# 3. Ouvrir le port 19999 dans le pare-feu
echo "Ouverture du port 19999/tcp dans le pare-feu..."

# --- Tentative avec firewalld d'abord ---
if command -v firewall-cmd &>/dev/null; then
  echo "Détection de firewalld : ouverture via firewall-cmd..."
  firewall-cmd --add-port=19999/tcp --permanent || true
  firewall-cmd --reload || true
else
  echo "firewalld non détecté, tentative via iptables..."
  # On vérifie si iptables est disponible
  if command -v iptables &>/dev/null; then
    iptables -I INPUT -p tcp --dport 19999 -j ACCEPT
    # À adapter selon Mageia pour la persistance (iptables-save / iptables.service etc.)
    if command -v iptables-save &>/dev/null; then
      iptables-save > /etc/iptables.rules
      echo "Si nécessaire, chargez /etc/iptables.rules au démarrage (selon votre config)."
    fi
  else
    echo "Aucun système de pare-feu détecté. Veuillez ouvrir le port manuellement si besoin."
  fi
fi

# 4. Vérification du statut Netdata
echo "Vérification du service Netdata..."
systemctl status netdata --no-pager || true

echo "============================================="
echo " Installation de Netdata terminée !"
echo " Accès web : http://[IP_SERVEUR]:19999"
echo "============================================="
```

## Comment utiliser ce script ?

1. **Télécharge** (ou clone) ce dépôt.  
2. **Rends le script exécutable** :  
   ```bash
   chmod +x install.sh
   ```  
3. **Exécute-le** en tant que root (ou via sudo) :  
   ```bash
   sudo ./install.sh
   ```  

Ensuite, Netdata devrait être installé, démarré, et écouter sur le port `19999`. Tu pourras vérifier l’accès via ton navigateur :

```
http://[IP-de-ton-serveur]:19999
```

---

> **Note** : Le script ci-dessus est volontairement minimaliste. N’hésite pas à gérer les particularités propres à Mageia (gestion des services iptables, SELinux, etc.) selon tes besoins.

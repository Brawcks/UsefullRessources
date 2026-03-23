# OpenClaw Integration Notes

Ce document rassemble les informations et les bonnes pratiques pour intégrer et administrer OpenClaw dans nos environnements.

## Objectif
Fournir une documentation concise pour :
- déployer OpenClaw
- configurer les agents
- gérer les accès et la sécurité
- opérations courantes (backup, mise à jour, troubleshooting)

## Déploiement rapide
1. Prérequis : Debian 12 LXC/VM, accès root, Docker (optionnel) ou environnement Python.
2. Installer OpenClaw : utiliser le one-liner fourni par l'équipe (ou clone du dépôt).
3. Vérifier le service : `openclaw gateway status`.

## Configuration initiale
- Lire et configurer : SOUL.md, USER.md, MEMORY.md dans le workspace `/root/.openclaw/workspace`.
- Ajouter utilisateurs approuvés dans `approved_users.list`.

## Mises à jour
- mettre à jour via package manager ou redéployer le conteneur/agent.
- sauvegarder `memory/` et `MEMORY.md` avant migration.

## Sécurité
- Garder les tokens et clés hors repo.
- Restreindre accès SSH; utiliser des comptes bots pour automation.

## Troubleshooting
- Vérifier `journalctl -u openclaw` et `openclaw gateway status`.
- Pour problèmes Docker dans LXC, vérifier les sysctl et runtime.


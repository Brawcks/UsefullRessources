# Proxmox config

Utile pour mettre en place des VM accessibles directement depuis l'extérieur.

## Configuration des interaces

Voir le fichier d'exemple "interfaces". Les ports web sont dirigés vers une VM / un CT, qui dispatche les requêtes : https://nginxproxymanager.com/

Il faut créer un Linux Bridge vmbr1 qui s'appuiera sur vmbr0.

## Nested pour docker

Il est nécessaire de modifier la configuration des CT pour utiliser la virtualisation avec Docker dans un CT !

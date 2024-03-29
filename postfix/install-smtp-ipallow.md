# Install Postfix - Autorisation par IP

L'install Postfix avec Autorisation de connexion par IP est très simple.

## Installation

Installer Postfix : 

```text
$ sudo apt install postfix
```

Lors de l'installation, définir lorsque demandé le domaine d'envoi.

Puis, une fois l'installation réalisée, modifier le fichier : **/etc/postfix/main.cf**. Modifiez simplement la ligne ci-bas :

```text
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 
    <ip_autorisée>/32 # Ajouter l'IP du serveur autorisé à l'envoi
```

## A faire absolument

Il est absolument nécessaire d'ajouter les règles IPTables qui assureront, en plus de la configuration de Postfix, qu'aucun autre serveur ne pourra se connecter sur ce serveur d'envoi.

**Il est très simple d'être blacklisté, donc la sécurité doit être maximale !**

Aussi : 

* Configurer SPF
* Configurer DKIM (idéalement)
* Configurer DMARC (Absolument, en reject).

## Configuration avancée

Penser à : 

* Définir un certificat SSL pour le Client SMTP
* Changer le port (25 -> 587)
* Configurer iptables pour ne permettre la connexion que depuis des serveurs autorisés.

Note : Le port se change ici : **cat /etc/postfix/master.cf**

```text
smtp      inet  n       -       y       -       -       smtpd # AVANT
587      inet  n       -       y       -       -       smtpd # APRES
```

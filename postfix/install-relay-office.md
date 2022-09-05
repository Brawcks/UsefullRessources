SMTP

1. Installation

Installer les paquets suivants : 

$ apt install -y certbot mailutils libsasl2-2 sasl2-bin procmail postfix

Lors de l’installation de Postfix, laisser les valeurs par défaut

Une fois l’installation faite, on passe à la modification des fichiers de configuration.

2. Configuration

/etc/mailname

domain.com


/etc/postfix/master.cf

Modifier la ligne suivante : 

smtp      inet  n       -       y       -       -       smtpd

Modifier par :

smtp      inet  n       -       n       -       -       smtpd

/etc/postfix/main.cf

# See /usr/share/postfix/main.cf.dist for a commented, more complete version


# Debian specific:  Specifying a file name will cause the first
# line of that file to be used as the name.  The Debian default
# is /etc/mailname.
#myorigin = /etc/mailname

smtpd_banner = $myhostname ESMTP $mail_name (Debian/GNU)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

readme_directory = no

# See http://www.postfix.org/COMPATIBILITY_README.html -- default to 2 on
# fresh installs.
compatibility_level = 2



# TLS parameters
smtpd_tls_cert_file=/etc/letsencrypt/live/mail.domain.com/cert.pem
smtpd_tls_key_file=/etc/letsencrypt/live/mail.domain.com/privkey.pem
smtpd_use_tls=yes
smtpd_tls_loglevel = 1
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

# See /usr/share/doc/postfix/TLS_README.gz in the postfix-doc package for
# information on enabling SSL in the smtp client.

smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = domain-mail-1.openstacklocal
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
myorigin = /etc/mailname
mydestination = $myhostname, domain-mail-1, localhost.localdomain, localhost
relayhost = [mail-domain-com.mail.protection.outlook.com]:25
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
inet_protocols = all

# Custom config
smtp_sasl_auth_enable = no
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_security_level = encrypt
header_size_limit = 409600
sender_canonical_classes = envelope_sender, header_sender
sender_canonical_maps = regexp:/etc/postfix/sender_canonical_maps
smtp_header_checks = regexp:/etc/postfix/header_check

# Auth
smtpd_sasl_auth_enable = yes
smtpd_sasl_security_options = noanonymous
smtpd_sasl_local_domain =
smtpd_tls_security_level = may
# smtp_sasl_auth_enable = no
broken_sasl_auth_clients = yes
smtpd_sasl_authenticated_header = yes
smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination

/etc/postfix/header_check

/FROM:.*/ REPLACE From: <from>@domain.com
/SENDER:.*/ REPLACE Sender: catchall@domain.com

/etc/postfix/sender_canonical_maps

/.+/  catchall@domain.com

/etc/postfix/sasl_passwd

[mail-domain-com.mail.protection.outlook.com]:25 catchall@domain.com:<mot_de_passe_ici>

Une fois ce fichier créé, créer le fichier db qui contiendra les identifiants via : 

sudo postmap /etc/postfix/sasl_passwd

/etc/default/saslauthd

Modifier les lignes : 

START=no
MECHANISMS=""

Modifier en :

START=yes
MECHANISMS="sasldb"

Puis redémarrer le service : 

/etc/init.d/saslauthd restart

Maintenant, on ajoute un utilisateur :

echo <mot_de_passe_ici> | saslpasswd2 -p -c -u domain.com catchall

Pour tester la connexion :

testsaslauthd -u catchall -r domain.com -p <mot_de_passe_ici>

En cas d’erreur sur le fichier stockant les comptes, supprimez le, puis relancez la commande d’ajout d’utilisateur.

On redémarre Postfix :

sudo service postfix restart

Installation terminée !

Attention, la connexion à Postfix se fait SANS TLS avec cette configuration.

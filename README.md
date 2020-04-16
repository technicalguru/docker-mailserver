# Overview
This is the Mailserver project. It aims to lock a complete mailserver into containers. Several sub-projects contribute here:

* docker-mailserver - This project. Compose all other images using Kubernetes, HELM or docker-compose
* docker-mailserver-postfix - The actual mailserver using Postfix and Dovecot
* docker-mailserver-postfixadmin - PostFixAdmin web interface to administrate the domains and mailboxes
* docker-mailserver-amavis - Anti-virus and spam-checking using Amavis, ClamAV and SpamAssassin
* docker-mailserver-roundcube - Webmail interface based on RoundCube 

Additionally, there is a MariaDB required in order to save all configurations.

# Timeline
The project is almost at a mature state. Please be patient for the first release. It shall come in April 2020.

# docker-mailserver
This is a project that aims at putting a mailserver into Docker containers. The obvious reason is 
that a good mailserver setup requires time and effort. And even when you have it installed on 
one server, you will need it to migrate ot sooner or later to another server or upgrade 
components of it. Why not locking the whole mailserver into a defined setup that can be moved easily
from one server to the next or from one Kubernetes cluster to the other.

This project tries to fulfill this goal by providing the appropriate Docker images and their respective
configuration scripts.

# Features
* A complete SMTP mailserver using TLS, DKIM, SPF and other modern capabilities
* Administrating domains and mailboxes on this server via Web UI
* Scanning incoming and outgoing e-mails for viruses and spam
* Reading and writing e-mails from anywhere in the world using a Web UI
* Maintaining all meta information in a database instead of files

# Sub-projects

* [docker-mailserver-postfix](https://github.com/technicalguru/docker-mailserver-postfix) - Postfix/Dovecot image (mailserver component)
* [docker-mailserver-postfixadmin](https://github.com/technicalguru/docker-mailserver-postfixadmin) - Image for PostfixAdmin (Web UI to manage mailboxes and domain in Postfix)
* [docker-mailserver-amavis](https://github.com/technicalguru/docker-mailserver-amavis) - Amavis, ClamAV and SpamAssassin (provides spam and virus detection)
* [docker-mailserver-roundcube](https://github.com/technicalguru/docker-mailserver-roundcube) - Roundcube Webmailer

# Versions
The following versions are available as releases. Sub-projects have their own lifecycle.

* [1.0.0, 1.0, 1, latest](https://github.com/technicalguru/docker-mailserver/tree/1.0.0)

# License
_docker-mailserver_  is licensed under [GNU LGPL 3.0](LICENSE.md).

# How to create your mailserver
A complete mailserver is the coordinated setup of multiple components. Various docker images come into play to fulfill this goal. You shall set them up in the following order:

1. [MySQL >8.0](https://hub.docker.com/\_/mysql) or [MariaDB >10.4](https://hub.docker.com/\_/mariadb) as the database backend
1. [Postfix/Dovecot instance](https://hub.docker.com/technicalguru/mailserver-postfix)
1. [Amavis/ClamAV/SpamAssassin instance](https://hub.docker.com/technicalguru/mailserver-amavis)
1. [PostfixAdmin instance](https://hub.docker.com/technicalguru/mailserver-postfixadmin)
1. [Roundcube](https://hub.docker.com/technicalguru/mailserver-roundcube)
1. Securing the web interfaces with a Reverse Proxy or Ingress Controller. (see section "Security Considerations" below)

The following sections will help you to setup your own mailserver using different infrastructures.

## Setup the mailserver with docker-compose

## Setup the mailserver with plain Kubernetes YAML files

## Setup the mailserver with HELM charts

# Security Considerations

# Issues
I use this composition of Docker images in a Kubernetes cluster to run my own mailserver productively. Minor issues exist at the moment (see sub-projects). But it runs stable :).

# Contribution
Report a bug, request an enhancement or pull request at the [GitHub Issue Tracker](https://github.com/technicalguru/docker-mailserver/issues).


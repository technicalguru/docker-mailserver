# docker-mailserver
This is a project that aims at putting a mailserver into Docker containers. The obvious reason is 
that a good mailserver setup requires time and effort. And even when you have it installed on 
one server, you will need to migrate it sooner or later to another server or upgrade 
components of it. Why not locking the whole mailserver into a defined setup that can be moved easily
from one server to the next or from one Kubernetes cluster to the other.

This project tries to fulfill this goal by providing the appropriate Docker images and their respective
configuration scripts.

# Features
* A complete SMTP mailserver using TLS, DKIM, SPF and other modern capabilities
* Administrating domains and mailboxes via a Web UI
* Scanning incoming and outgoing e-mails for viruses and spam
* Moves spam into Spam folder of your mailbox automatically (when spam recognition is on)
* User-specific sieve rules enabled
* Reading and writing e-mails from anywhere in the world using a Web UI
* Maintaining all meta information in a database instead of files

# Sub-projects

* [docker-mailserver-postfix](https://github.com/technicalguru/docker-mailserver-postfix) - Postfix/Dovecot image (mailserver component)
* [docker-mailserver-opendkim](https://github.com/technicalguru/docker-mailserver-opendkim) - OpenDKIM image (DKIM signing milter component)
* [docker-mailserver-postfixadmin](https://github.com/technicalguru/docker-mailserver-postfixadmin) - Image for PostfixAdmin (Web UI to manage mailboxes and domain in Postfix)
* [docker-mailserver-amavis](https://github.com/technicalguru/docker-mailserver-amavis) - Amavis, ClamAV and SpamAssassin (provides spam and virus detection)
* [docker-mailserver-roundcube](https://github.com/technicalguru/docker-mailserver-roundcube) - Roundcube Webmailer

# Versions
The following versions are available as releases. Sub-projects have their own lifecycle.

* [1.1.1, 1.1, 1, latest](https://github.com/technicalguru/docker-mailserver/tree/v1.1.1)
* [1.0.0, 1.0](https://github.com/technicalguru/docker-mailserver/tree/v1.0.0)

# License
_docker-mailserver_  is licensed under [GNU LGPL 3.0](LICENSE.md).

# How to create your mailserver
A complete mailserver is the coordinated setup of multiple components. Various docker images come into play to fulfill this goal. You shall set them up in the following order:

1. [MySQL >8.0](https://hub.docker.com/\_/mysql) or [MariaDB >10.4](https://hub.docker.com/\_/mariadb) as the database backend
1. [Postfix/Dovecot instance](https://hub.docker.com/repository/docker/technicalguru/mailserver-postfix)
1. [OpenDKIM instance](https://github.com/technicalguru/docker-mailserver-opendkim) (optional)
1. [Amavis/ClamAV/SpamAssassin instance](https://hub.docker.com/repository/docker/technicalguru/mailserver-amavis)
1. [PostfixAdmin instance](https://hub.docker.com/repository/docker/technicalguru/mailserver-postfixadmin)
1. [Roundcube](https://hub.docker.com/repository/docker/technicalguru/mailserver-roundcube)
1. Securing the web interfaces with a Reverse Proxy or Ingress Controller. (see section "Security Considerations" below)

The following sections will help you to setup your own mailserver using different infrastructures.

## Setup the mailserver with docker-compose
Please refer to the special [docker-compose](examples/docker-compose) section.

## Setup the mailserver with plain Kubernetes YAML files
Please refer to the special [Kubernetes](examples/kubernetes) section.

## Setup the mailserver with HELM charts on a Kubernetes cluster
Please refer to the special [HELM](examples/helm-charts) section.

# Security Considerations

* It is crucial that you do not expose port 10025 of the [mailserver-postfix](https://hub.docker.com/repository/docker/technicalguru/mailserver-postfix)
  container. It can be misused as a SPAM relay as it does not restrict senders that deliver mail to it. This port is intended for
  internal purposes only. The same is valid for the port 10024 of the [mailserver-amavis](https://hub.docker.com/repository/docker/technicalguru/mailserver-amavis)
  container.
* Postfix's main ports can be protected by TLS. Please make use of this as it increases security of your setup. In fact,
  the Postfix setup was never tested thoroughly without TLS so it is possible it will not work properly - especially when
  passwords are required.
* PostfixAdmin, OpenDKIM and Roundcube provide Web User Interfaces that are exposed as HTTP only. An attacker could easily copy your network
  traffic and read your passwords. Make sure you have an appropriate Ingress Controller or Reverse Proxy in front and your traffic
  is routed internally on your host only. 
* If your internal network traffix in a Kubernetes cluster is crossing node borders, you will need to ensure that it is encrypted.
  The default setup of these containers do not configure this. However, you can use Istio, Consul or linkerd in order to achieve
  this goal.

# Issues
I use this composition of Docker images in a Kubernetes cluster to run my own mailserver productively. Minor issues exist at the moment (see sub-projects). 
But it runs stable and you can be ensured I release image fixes as soon as I detect any bugs or security flaws. :).

# Contribution
Report a bug, request an enhancement or pull request at the [GitHub Issue Tracker](https://github.com/technicalguru/docker-mailserver/issues). Make sure you have checked out the [Contribution Guideline](CONTRIBUTING.md)



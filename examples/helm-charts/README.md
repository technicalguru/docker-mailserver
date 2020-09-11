# Deployment using HELM charts

This page explains how to use the HELM charts for the composition of all containers.

# HOWTO

## Prerequisites

Several assumptions are made for this example. Please make sure you fulfill them. Otherwise you need to adjust the
YAML files and commands accordingly.
* You have a running Kubernetes cluster and you are familiar with HELM 3 and HELM templates.
* The mailserver will run in any namespace that you ask HELM to deploy in. The namespace is setup already.
* It is also assumed that you have an Ingress configured in your cluster that points to these services:
    * `https://<your-web-domain-name>/postfixadmin` => `http://postfixadmin.mailserver.svc.cluster.local`
    * `https://<your-web-domain-name>/roundcube` => `http://roundcube.mailserver.svc.cluster.local`
    * It terminates the SSL/TLS encryption and all traffic within your cluster is not encrypted.
    * The SSL certificate is available to you with private key, certificate and certificate chain.
* All persistent data will be stored on host volumes. Usually you want to change this in the template files. The
  examples are kept simple for this purpose. Especially the postfix, amavis and mariadb containers require
  persistent data. If you want to stick a pod to a specific node in your cluster, please refer to the
  Postfix setup description for an example.
* You are familiar with MariaDB or MySQL administration. There are a few commands to be executed directly
  on your database. A [PhpMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin/) pod could help you here.

## Configure the HELM repository

Execute the following command to add the HELM repository to your client and load its content:

```
helm repo add technicalguru https://raw.githubusercontent.com/technicalguru/helm-repo/master/repo
helm repo update
```

## Copy the original values.yaml file

Make sure you are working in your home directory (or whatever path you want to work in). Then download
the [`values.yaml`](https://raw.githubusercontent.com/technicalguru/helm-repo/master/src/mailserver/values.yaml) file e.g. via wget:

```
wget -O my-values.yaml https://raw.githubusercontent.com/technicalguru/helm-repo/master/src/mailserver/values.yaml
```

## Define you deployment values

You can now edit the `my-values.yaml` file directly and set all individual variables for your deployment.

* You can comment out or delete variable that you do not change. HELM will use the default values from `values.yaml`
  or the underlying sub-charts.
* You can add values in the individual sections in case you want to change some of the values. Refer to
  the in-file documentation of these values.
* Make sure that your TLS certificate for Postfix is available. The template will not create any TLS certificate
  configuration if the file is not accessible. Do not set the TLS certificate values in your values file (although you can)
  but rather use the `--set-file=...` command line option to HELM in order to pass the content of these files into the
  respective values.

## Deploy into your Kubernetes cluster

You can inspect the result of your deployment in advance by issuing the following command. `my-mailserver` 
is the installation name that HELM will use for referencing it. The closing dot refers to the current
directory.

```
helm template \
   --namespace mailserver \
   --values my-values.yaml \
   --set-file=postfix.tlsCertificate=/path/to/cert.pem,postfix.tlsCertificateChain=/path/to/fullchain.pem,postfix.tlsKey=/path/to/privkey.pem \
   my-mailserver technicalguru/mailserver:1.0.0
```

Check the output whether the Kubernetes YAML files are what you had in mind when defining the values.
Once you are satisfied with the result, finally install into you cluster:

```
helm install \
   --namespace mailserver \
   --values my-values.yaml \
   --set-file=postfix.tlsCertificate=/path/to/cert.pem,postfix.tlsCertificateChain=/path/to/fullchain.pem,postfix.tlsKey=/path/to/privke.pem \
   my-mailserver technicalguru/mailserver:1.0.0
```

## Setup your Domain and  Mailboxes

Now, everything is complete to actually create your domains and mailboxes. Follow the instructions as given in
[mailserver-postfixadmin](https://github.com/technicalguru/docker-mailserver-postfixadmin) documentation.

## Setup DKIM Signing

The OpenDKIM container does not create any keys (yet). Please follow the key setup instruction of the 
[mailserver-opendkim](https://github.com/technicalguru/docker-mailserver-opendkim) documentation.

## Setup Roundcube WebMailer

Roundcube will require a correct database setup. It can create all the schema tables itself but the database
and the user must be present up-front. Go to your database CLI and issue:

```
CREATE DATABASE roundcube;
CREATE USER 'roundcube'@'%' IDENTIFIED BY '<my-roundcube-password>';
GRANT ALL PRIVILEGES ON roundcube.* TO 'roundcube'@'%' WITH GRANT OPTION;
```

You need to execute some further first-time installation steps. Follow the instructions as given in
[mailserver-roundcube](https://github.com/technicalguru/docker-mailserver-roundcube) documentation.

# Congratulations!

The setup of the mailserver is complete now. Feel free to give feedback or report bugs and change requests
at the individual components' issue trackers or at this main [Issue Tracker](https://github.com/technicalguru/docker-mailserver/issues).

# Customizing the HELM charts

Of course you can change the HELM charts. You will find the sources at GitHub:

> [https://github.com/technicalguru/helm-repo](https://github.com/technicalguru/helm-repo)

You can easily clone it into your home directory and work from there:

```
git clone https://github.com/technicalguru/helm-repo.git
```


# Deployment using Kubernetes YAML files

These examples use Kubernetes YAML files that you will need to deploy with:

```
kubectl apply -f <yaml-file>
```

# HOWTO

## Prerequisites

Several assumptions are made for this example. Please make sure you fulfill them. Otherwise you need to adjust the
YAML files and commands accordingly.
* You have a running Kubernetes cluster and you are familiar with Kubernetes `kubectl` command
and YAML files.
* The mailserver will run in namespace `mailserver`. The namespace is setup already.
* It is also assumed that you have an Ingress configured in your cluster that points to these services:
    * `https://<your-web-domain-name>/postfixadmin` => `http://postfixadmin.mailserver.svc.cluster.local`
    * `https://<your-web-domain-name>/roundcube` => `http://roundcube.mailserver.svc.cluster.local`
    * It terminates the SSL/TLS encryption and all traffic within your cluster is not encrypted.
    * The SSL certificate is available to you with private key, certificate and certificate chain. 
* All persistent data will be stored on host volumes. Usually you want to change this in the YAML files. The 
  examples are kept simple for this purpose. Especially the postfix, amavis and mariadb containers require
  persistent data. If you want to stick a pod to a specific node in your cluster, please refer to the
  Postfix setup description for an example.
* You are familiar with MariaDB or MySQL administration. There are a few commands to be executed directly
  on your database. A [PhpMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin/) pod could help you here.

## Clone the Git Repository

Make sure you are working in your home directory (or whatever path you want to work in)

```
git clone https://github.com/technicalguru/docker-mailserver.git
cd docker-mailserver/examples/kubernetes
```

## Setup Database

Check the `configmaps/mariadb.yaml` file. It shall fulfill basic needs out of the box.
If the configuration is ok for you then apply it:

```
kubectl apply -f configmaps/mariadb.yaml
```

Check the `services/mariadb.yaml` file. It shall fulfill basic needs out of the box.
If the service definition is ok for you then apply it:

```
kubectl apply -f services/mariadb.yaml
```

Check the `deployments/mariadb.yaml` file. Adjust the password (root) and the host volume
definition if required. Also notice that you will need to stick the Pod to a specific
node in your cluster in case you use the example of a host volume. See the Postfix setup
for an example.

```
kubectl apply -f deployments/mariadb.yaml
```

Check that your MariaDB pod is up and running:

```
kubectl get pods -n mailserver
```

Also check that the new pod has no issues. Use `kubectl logs <pod-name>` or your logging infrastructure.

## Setup Postfix

Check the `secrets/tls-certificate.yaml` file. It requires you to add the contents
of your certificate, private key and certificate chain. You can add the values
directly in the YAML file by putting the pure certificate data without line breaks and
header/footer lines. If the file is adjusted then apply it:

```
kubectl apply -f secrets/tls-certificate.yaml
```

As Postfix is designed here to run on one node only, you will need to label this node first
so we can stick the pod to it later:

```
kubectl label node <your-node-name> mailserver/environment=mailserver
```

Now, check the `services/postfix.yaml` and `services/postfix-internal.yaml`files. Please notice
that you need to add your node's IP address in the file so the SMTP and IMAP ports are
exposed on one node only - however multiple DNS MX records can be used to make the service
available on all nodes. Then you will require a `NodePort` definition here.

Create the services and issue:

```
kubectl apply -f services/postfix.yaml
kubectl apply -f services/postfix-internal.yaml
```

Finally, adust the `deployments/postfix.yaml` file. It requires you to change the
the passwords and basic mail setup data. A complete description can be found
in the [mailserver-postfix](https://github.com/technicalguru/docker-mailserver-postfix) documentation.
Pay attention to the volume definitions, too. If the deployment definition is ok for 
you then apply it:

```
kubectl apply -f deployments/postfix.yaml
```

Check that your Postfix pod is up and running:

```
kubectl get pods -n mailserver
```

Also check that the new pod has no issues. Use `kubectl logs <pod-name>` or your logging infrastructure.

## Setup OpenDKIM

Check the `services/opendkim.yaml` file. If the service definition fits
then create the service:

```
kubectl apply -f services/opendkim.yaml
```

Second, adust the `deployments/opendkim.yaml` file. It requires you to change the
database and domain data. A complete description can be found
in the [mailserver-opendkim](https://github.com/technicalguru/docker-mailserver-opendkim) documentation.
If the deployment definition is ok for you then apply it:

```
kubectl apply -f deployments/opendkim.yaml
```

You need to execute some further steps in order to setup signing keys. Follow the instructions as given in
[mailserver-opendkim](https://github.com/technicalguru/docker-mailserver-opendkim) documentation.

## Setup Amavis Virus and Spam Checker

Check the `services/amavis.yaml` file. If the service definition fits
then create the service:

```
kubectl apply -f services/amavis.yaml
```

Second, adust the `deployments/amavis.yaml` file. It requires you to change the
basic mail setup data. A complete description can be found
in the [mailserver-amavis](https://github.com/technicalguru/docker-mailserver-amavis) documentation.
Pay attention to the volume definitions, too. If the deployment definition is ok for 
you then apply it:

```
kubectl apply -f deployments/amavis.yaml
```

Check that your Amavis pod is up and running:

```
kubectl get pods -n mailserver
```

Also check that the new pod has no issues. Use `kubectl logs <pod-name>` or your logging infrastructure.

Although your mailserver is up and running, it cannot accept mails yet as there are no domains and
mailboxes defined in your database. You will need the PostfixAdmin first.

## Setup PostfixAdmin

Check the `services/postfixadmin.yaml` file. If the service definition fits
then create the service:

```
kubectl apply -f services/postfixadmin.yaml
```

Second, adust the `deployments/postfixadmin.yaml` file. It requires you to change the
password and basic mail setup data. A complete description can be found
in the [mailserver-postfixadmin](https://github.com/technicalguru/docker-mailserver-postfixadmin) documentation.
If the deployment definition is ok for you then apply it:

```
kubectl apply -f deployments/postfixadmin.yaml
```

Check that your PostfixAdmin pod is up and running:

```
kubectl get pods -n mailserver
```

Also check that the new pod has no issues. Use `kubectl logs <pod-name>` or your logging infrastructure.

Now, everything is complete to actually create your domains and mailboxes. Follow the instructions as given in
[mailserver-postfixadmin](https://github.com/technicalguru/docker-mailserver-postfixadmin) documentation.

## Setup Roundcube WebMailer

Roundcube will require a correct database setup. It can create all the schema tables itself but the database
and the user must be present up-front. Go to your database CLI and issue:

```
CREATE DATABASE roundcube;
CREATE USER 'roundcube'@'%' IDENTIFIED BY '<my-roundcube-password>';
GRANT ALL PRIVILEGES ON roundcube.* TO 'roundcube'@'%' WITH GRANT OPTION;
```

Once database and user are setup, check the `services/roundcube.yaml` file. If the service definition fits
then create the service:

```
kubectl apply -f services/roundcube.yaml
```

Second, adust the `deployments/roundcube.yaml` file. It requires you to change the
password and DB setup data. A complete description can be found
in the [mailserver-roundcube](https://github.com/technicalguru/docker-mailserver-roundcube) documentation.
If the deployment definition is ok for you then apply it:

```
kubectl apply -f deployments/roundcube.yaml
```

Check that your Roundcube pod is up and running:

```
kubectl get pods -n mailserver
```

Also check that the new pod has no issues. Use `kubectl logs <pod-name>` or your logging infrastructure.

You need to execute some further first-time installation steps. Follow the instructions as given in
[mailserver-roundcube](https://github.com/technicalguru/docker-mailserver-roundcube) documentation.

# Testing your Mailserver

Here are some useful links that help you to test whether your new Mailserver works as intended and no security flaws are introduced:

* [**Relay Test**](http://www.aupads.org/test-relay.html) - checks whether your mailserver can be misused as an open mail gateway (relay)
* [**TLS Test**](https://www.checktls.com/) - checks whether your TLS configuration is complete and works as intended
* [**SMTP Test**](https://mxtoolbox.com/diagnostic.aspx) - A general mailserver diagnostic tool
* [**DMARC DKIM Record Checker**](https://www.dmarcanalyzer.com/how-to-validate-a-domainkey-dkim-record/) - checks correctness of your DKIM DNS TXT entry
* [**DKIM Check**](https://www.appmaildev.com/en/dkim) - verifies your DKIM signing feature by giving you a temporary recipient address where you send a test mail

# Congratulations!

The setup of the mailserver is complete now. Feel free to give feedback or report bugs and change requests
at the individual components' issue trackers or at this main [Issue Tracker](https://github.com/technicalguru/docker-mailserver/issues).


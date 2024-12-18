```
version: '3.9'

services:
  database:
    image: mariadb:10.5
    container_name: mailserver_database
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: example_root_password
      MYSQL_DATABASE: postfix
      MYSQL_USER: postfix
      MYSQL_PASSWORD: example_password
    volumes:
      - db_data:/var/lib/mysql

  postfix:
    image: technicalguru/docker-mailserver-postfix
    container_name: mailserver_postfix
    restart: unless-stopped
    environment:
      DB_HOST: database
      DB_USER: postfix
      DB_PASS: example_password
    ports:
      - "25:25"
      - "465:465"
      - "587:587"
    volumes:
      - postfix_data:/var/mail
      - ./config/postfix:/etc/postfix:ro

  opendkim:
    image: technicalguru/docker-mailserver-opendkim
    container_name: mailserver_opendkim
    restart: unless-stopped
    volumes:
      - opendkim_data:/etc/opendkim

  amavis:
    image: technicalguru/docker-mailserver-amavis
    container_name: mailserver_amavis
    restart: unless-stopped
    ports:
      - "10024:10024"
    environment:
      - AMAVIS_LOGLEVEL=1

  postfixadmin:
    image: technicalguru/docker-mailserver-postfixadmin
    container_name: mailserver_postfixadmin
    restart: unless-stopped
    environment:
      DB_HOST: database
      DB_USER: postfix
      DB_PASS: example_password
      DB_NAME: postfix
    ports:
      - "8080:80"

  roundcube:
    image: technicalguru/docker-mailserver-roundcube
    container_name: mailserver_roundcube
    restart: unless-stopped
    environment:
      DB_HOST: database
      DB_USER: postfix
      DB_PASS: example_password
    ports:
      - "80:80"

volumes:
  db_data:
  postfix_data:
  opendkim_data:
```

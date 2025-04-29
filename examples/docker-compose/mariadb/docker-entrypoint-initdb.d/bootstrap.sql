CREATE DATABASE postfix;
CREATE USER 'postfix'@'%' IDENTIFIED BY 'example_postfix_password';
GRANT ALL PRIVILEGES ON postfix.* TO 'postfix'@'%';

CREATE DATABASE opendkim;
CREATE USER 'opendkim'@'%' IDENTIFIED BY 'example_opendkim_password';
GRANT ALL PRIVILEGES ON opendkim.* TO 'opendkim'@'%';

CREATE DATABASE roundcube;
CREATE USER 'roundcube'@'%' IDENTIFIED BY 'example_roundcube_password';
GRANT ALL PRIVILEGES ON roundcube.* TO 'roundcube'@'%';

FLUSH PRIVILEGES;
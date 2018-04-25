#!/bin/bash

###############################################################
### 														                            ###
###						LDAP SERVER SETUP 					                  ###
###															                            ###
###############################################################

yum -y update
yum -y install epel-release wget vim net-tools
yum -y install openldap-servers openldap-clients

cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG

chown ldap. /var/lib/ldap/DB_CONFIG

systemctl start slapd
systemctl enable slapd

#### Set openLDAP admin password

ldapadd -Y EXTERNAL -H ldapi:/// -f chrootpw.ldif 

#### Import basic schemas

ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif 
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif 
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif 

#### Setting domain name on LDAP DB

ldapmodify -Y EXTERNAL -H ldapi:/// -f chdomain.ldif

ldapadd -x -D cn=Manager,dc=scm4u,dc=com -w ldapadmin -f basedomain.ldif 

#### Firewall conf - LDAP uses 389/tcp

firewall-cmd --add-service=ldap --permanent 
firewall-cmd --reload 


#### Add a user (username and password: ciuser)

ldapadd -x -D cn=Manager,dc=scm4u,dc=com -w ldapadmin -f ciuser.ldif

#### Add users and groups in local passwd/group to LDAP directory

chmod +x local2ldapusers.sh

/bin/bash local2ldapusers.sh


#### LDAP Client Setup

yum -y install openldap-clients nss-pam-ldapd

authconfig --enableldap --enableldapauth --ldapserver=ldap.scm4u.com --ldapbasedn="dc=scm4u,dc=com" --enablemkhomedir --update

#### Install httpd to configure Web Server. HTTP uses 80/TCP

yum -y install httpd

rm -f /etc/httpd/conf.d/welcome.conf

#### Configure httpd. Replace server name to your own environment.

mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.orig

cp httpd.conf /etc/httpd/conf/

systemctl start httpd 
systemctl enable httpd 

#### Allow HTTP service through firewall. HTTP uses 80/TCP

firewall-cmd --add-service=http --permanent 
firewall-cmd --reload 

cp index.html /var/www/html/

#### Test URL: http://ldap.scm4u.com/

#### Install PHP

yum -y install php php-mbstring php-pear

mv /etc/php.ini /etc/php.ini.orig
cp php.ini /etc/

systemctl restart httpd 

cp index.php /var/www/html/

#### Test URL: http://ldap.scm4u.com/index.php

#### Install phpLDAPadmin

yum -y install phpldapadmin


mv /etc/phpldapadmin/config.php /etc/phpldapadmin/config.php.orig
cp config.php /etc/phpldapadmin/

mv /etc/httpd/conf.d/phpldapadmin.conf /etc/httpd/conf.d/phpldapadmin.conf.orig
cp phpldapadmin.conf /etc/httpd/conf.d/

systemctl restart httpd


#### LDAP Admin Console: http://ldap.scm4u.com/ldapadmin/
#### 					 http://ldap.scm4u.com/phpldapadmin/

# Login DN: cn=Manager,dc=scm4u,dc=com
# Password: ldapadmin

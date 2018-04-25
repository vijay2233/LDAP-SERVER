# LDAP-SERVER
OpenLDAP server with phpLDAPAdmin complete setup

Execute ldap_setup.sh script using root user

chmod +x ldap_setup.sh

chmod +x local2ldapusers.sh

sh ldap_setup.sh

If you get error saying "bad interpreter: no such file or directory"

Run following command in terminal

sed -i -e 's/\r$//' ldap_setup.sh
sed -i -e 's/\r$//' local2ldapusers.sh

Finally, You can test/login to the LDAP Server at below URL's

http://hostname/ldapadmin/  OR http://hostname/phpldapadmin/

NOTE: Hostname and Ip address my vary, so please use your's as set the host name and all in the scritps.

# LDAP-SERVER
OpenLDAP server with phpLDAPAdmin complete setup

Execute ldap_setup.sh script using root user

chmod +x ldap_setup.sh

sh ldap_setup.sh

If you get error saying "bad interpreter: no such file or directory"
Run following command in terminal

sed -i -e 's/\r$//' scriptname.sh

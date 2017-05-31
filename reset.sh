#!/bin/bash
#Changes every cPanel password on the server and stores the credentials in ~/newCredentials
#$newPassword is a randomly generated password with 10 characters
export ALLOW_PASSWORD_CHANGE=1
ls -la /home | awk '{print $3}' | grep -v root | grep -v wheel | grep -v cpanel | grep -v apache | grep -v csf | grep -v '^$' > /tmp/usersforchpass
for i in `more /tmp/usersforchpass `
do
        newPassword=$(</dev/urandom tr -dc 'A-Za-z0-9' | head -c10)
        echo "Username: $i" >> ~/newCredentials
        echo "Password: $newPassword" >> ~/newCredentials
        echo "" >> ~/newCredentials
        /scripts/chpass $i $newPassword
        /scripts/mysqlpasswd $i $newPassword
done
/scripts/ftpupdate
rm -f /tmp/usersforchpass
exit 0

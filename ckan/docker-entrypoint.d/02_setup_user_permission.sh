#!/bin/bash

echo '*** Setup User permission in /srv/app directory'
chown -R ckan-sys:ckan-sys .

echo '*** Setup User create ckan/i18n directory'
mkdir -p /var/lib/ckan/i18n

echo '*** Setup User permission in volume directory (/var/lib/ckan)'
chown -R ckan-sys:ckan-sys /var/lib/ckan

# change user to ckan-sys during setup "entrypoint" runtime
# exec su ckan-sys -s /bin/bash -c "$*"

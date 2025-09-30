#!/bin/bash

chown -R ckan:ckan /var/lib/ckan
exec "$@"
ckan asset build
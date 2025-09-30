#!/bin/bash
set -e

# Make sure directory exists
#mkdir -p /var/lib/ckan/i18n
# Fix permissions before anything else
#chown -R ckan:ckan /var/lib/ckan

ckan asset build

# Run CKAN as the ckan user
exec gosu ckan "$@"
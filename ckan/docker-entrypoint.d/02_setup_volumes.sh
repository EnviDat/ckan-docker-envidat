#!/bin/bash
set -e

echo "[entrypoint] Ensuring /var/lib/ckan exists and has correct permissions..."
mkdir -p /var/lib/ckan/storage /var/lib/ckan/webassets /var/lib/ckan/i18n
chown -R ckan:ckan-sys /var/lib/ckan

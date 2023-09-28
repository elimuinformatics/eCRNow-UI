#!/bin/sh

# nginx config variable injection
envsubst '${AUTH_BASIC}' < /etc/nginx/conf.d/default.conf | sponge /etc/nginx/conf.d/default.conf

# htpasswd for basic authentication
htpasswd -c -b /etc/nginx/.htpasswd $AUTH_BASIC_USERNAME $AUTH_BASIC_PASSWORD

# uncomment the following lines to show the nginx configuration in the logs for debugging purposes
# cat /etc/nginx/.htpasswd
# cat /etc/nginx/nginx.conf
# cat /etc/nginx/conf.d/default.conf

exec "$@"
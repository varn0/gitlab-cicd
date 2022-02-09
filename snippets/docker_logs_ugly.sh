#!/bin/bash

################################################################
##
## Save api, ngix logs
## Written By: Alejo
## URL: http://ftp.xyz.com/scripts/
## Last Update: Ago 14, 2020
##
################################################################
export PATH=/bin:/usr/bin:/usr/local/bin

API_ID=$(docker container ls --format "{{.ID}}{{.Image}}"| grep -E "dtaxi-api"| cut -c 1-12)

NGINX_ID=$(docker container ls --format "{{.ID}}{{.Image}}"| grep -E "nginx"| cut -c 1-12)

echo 'Salvando logs'

docker container logs "${API_ID}" > api.logs
docker container logs "${NGINX_ID}" > nginx.logs

#End of script



crontab



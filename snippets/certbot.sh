#! /bin/bash

#### DNS Challange ###
#docker run --rm -it \
#  --name=certbot \
#  --volume="$(pwd)/certbot/conf:/etc/letsencrypt" \
#  --volume="$(pwd)/certbot/www:/var/www/certbot" \
#  certbot/certbot \
#  certonly \
#  -d '*.companyxyz.com' \
#  -d companyxyz.com \
#  --email ajanerom@gmail.com \
#  --manual \
#  --preferred-challenges dns
#! /bin/bash


DOMAINS=(web1.companyxyz.com web2.companyxyz.com )
path="/etc/letsencrypt/live/$domain"
rsa_key_size=4096
DATA_PATH="./certbot"
#EMAIL="ajanerom@gmail.com" # Adding a valid address is strongly recommended


for domain in "${DOMAINS[@]}"
do
  echo "### Creating dummy certificate for DOMAINS ..."

  mkdir -p "$DATA_PATH/conf/live/$domain"
  echo "$path/privkey.pem"
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout "$DATA_PATH/conf/live/$domain/privkey.pem" \
    -out "$DATA_PATH/conf/live/$domain/fullchain.pem" \
    -subj '/CN=companyxyz.com'
  echo
done


for domain in "${DOMAINS[@]}"
do
  docker run --rm -i \
    --name=certbot \
    --volume="$(pwd)/certbot/conf:/etc/letsencrypt" \
    --volume="$(pwd)/certbot/www:/var/www/certbot" \
    --network="router-net" \
    certbot/certbot \
    certonly \
    --webroot -w /var/www/certbot \
    --staging \
    --email ajanerom@gmail.com \
    -d $domain \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --force-renewal
    echo
done






#!/bin/bash

################################################################
##
##   Script Deploy WP sites
##   Alexis Janero
##   xyz Solutions
##
################################################################
### Testing purposes ###
## more testing ###
PREFIX="wp_"
DB_NAME="${2}"
DB_USER="root"
DB_PASSWORD="ecsi*159951"
DB_HOST="127.0.0.1"
DB_BACKUP_FILE=""


# Configure WP settings
echo "-- Configurando WP settings --"
chmod -R 755 "$1"
cd "$1"/ || exit
rm -r .idea/
rm -r .git*

if [ -e wp-config.php ]; then
  cp wp-config.php{,.original}
  sed -i "s#define( 'DB_NAME', '\(.*\)' );#define( 'DB_NAME', '${DB_NAME}' );#" wp-config.php
  sed -i "s#define( 'DB_USER', '\(.*\)' );#define( 'DB_USER', '${DB_USER}' );#" wp-config.php
  sed -i "s#define( 'DB_PASSWORD', '\(.*\)' );#define( 'DB_PASSWORD', '${DB_PASSWORD}' );#" wp-config.php
  sed -i "s#define( 'DB_HOST', '\(.*\)' );#define( 'DB_HOST', '${DB_HOST}' );#" wp-config.php
  sed -i -e 's/\r$//' wp-config.php #Fix Windows end of line
  PREFIX=$(sed -n "s#\$table_prefix = '\(.*\)';#\1#p" wp-config.php)
  echo ${PREFIX}
else
  cp ../wp_settings/wp-config.php ./
  sed -i "s/database_name_here/${DB_NAME}/" wp-config.php
  sed -i 's/username_here/${DB_USER}/' wp-config.php
  sed -i 's/password_here/${DB_PASSWORD}/' wp-config.php
  sed -i 's/localhost/${DB_HOST}/' wp-config.php
  DB_NAME=$(ls *.sql)
  PREFIX=${DB_NAME:0:4}
  sed -i "s#\$table_prefix = '\(.*\)';#\$table_prefix = '${PREFIX}';#" wp-config.php
fi

echo ${PREFIX}

echo "-- Configurando .htaccess --"
if [ -e .htaccess ]; then
  cp .htaccess htaccess.original
  cp ../wp_settings/htaccess.default .htaccess
else
  cp ../wp_settings/htaccess.default .htaccess
fi
cd ../

# Copy Security Plugins
#echo "-- Copiando los plugin de seguridad --"
#cp security_plugins/*.zip "$1"/wp-content/plugins


# Reemplazar proyecto
echo "-- Cargando la base de datos --"

rm -r /var/www/"$1"
cp -r "$1" /var/www/

# Load Database
cd /var/www/"$1" || exit
chown -R www-data.www-data ../"$1"

DB_NAME=$(ls *.sql)
PREFIX=${DB_NAME:0:4}

mysql -uroot -pecsi*159951 -e "CREATE DATABASE IF NOT EXISTS $1"
mysql -uroot -pecsi*159951 "${DB_NAME}" < "${DB_BACKUP_FILE}"
mysql -uroot -pecsi*159951 "${DB_NAME}" -e "UPDATE ${PREFIX}options SET option_value='http://$1.xyz.com' WHERE option_name='siteurl';" \
			        -e "UPDATE ${PREFIX}options SET option_value='http://$1.xyz.com' WHERE option_name='home';" \
			        -e "UPDATE ${PREFIX}options SET option_value='/%postname%/' WHERE option_name='permalink_structure';"

rm ${DB_NAME}

    ## Unzip Plugins
    ##echo "-- Descomprimiendo los plugins --"
    ##cd /var/www/"$1"/wp-content/plugins
    ##for plugin in /var/www/"$1"/wp-content/plugins/*.zip; do
    ##    unzip -o ${plugin}
    ##    rm ${plugin}
    ##done

#echo "-- Comprobando la configuracion de Apache --"
cd /etc/apache2/sites-available/ || exit
if [ -e "$1".conf ]; then
  echo 'Ya hay un virtual host para este sitio'
else
  cp /home/xyz/wp_settings/vh.conf ./"$1".conf
  sed -i "s/site_name/$1/" "$1".conf
fi
a2ensite "$1".conf
systemctl reload apache2


        #if [ $? -eq 0 ]; then
        #  echo "Se desplego correctamente"
        #else
        #  echo "Error found during deploy"
        #  exit 1
        #fi



echo "-- Limpiando despliegue --"
cd /home/xyz || exit
rm -r "$1"

### End of script ####

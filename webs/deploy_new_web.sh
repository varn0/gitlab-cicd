#!/bin/bash
HOME="/home/ubuntu/wordpress"
# ${1} es PROJECT
# ${2} es PREFIX
DB_USER="<the_user>"
DB_PASS="<the_pass>"
DB_HOST="db:3306"

if [ ! -d $HOME/webs/"$1" ]; then
  mkdir $HOME/webs/"$1"
else
  echo "La carpeta de proyecto ya existe"
  exit 0
fi

if [ ! -e $HOME/webs/"$1"/wp-config.php ]; then
  echo "Creando wp-config.php"
  cp $HOME/utils/wp-config-sample.php $HOME/webs/"$1"/wp-config.php || exit 1
  sed -i "s/database_name_here/${1}/" $HOME/webs/"$1"/wp-config.php
  sed -i "s/username_here/${DB_USER}/" $HOME/webs/"$1"/wp-config.php
  sed -i "s/password_here/${DB_PASS}/" $HOME/webs/"$1"/wp-config.php
  sed -i "s/localhost/${DB_HOST}/" $HOME/webs/"$1"/wp-config.php
  sed -i "s#\$table_prefix = '\(.*\)';#\$table_prefix = '${2}_';#" $HOME/webs/"$1"/wp-config.php
  sed -i "/'WP_DEBUG'/ a define( 'WP_AUTO_UPDATE_CORE', false );" $HOME/webs/"$1"/wp-config.php
fi

echo "Creando Dockerfile"
if [ ! -e $HOME/webs/"$1"/Dockerfile ]; then
  echo "Creando Dockerfile"
  cp $HOME/utils/Dockerfile $HOME/webs/"$1"/Dockerfile || exit 1
  sed -i "s/project/$1/" $HOME/webs/"$1"/Dockerfile
fi

echo "Building docker image"
cd $HOME/webs/"$1" || exit
docker build -t "$1":1.0 .
cd || exit

echo "Creando compose para el servicio"
cp $HOME/utils/project-compose.yml $HOME/compose/"$1"-compose.yml
sed -i "s#project#$1#g" $HOME/compose/"$1"-compose.yml
sed -i "s#wp_#$2_#" $HOME/compose/"$1"-compose.yml


echo "Levantar compose"
docker-compose -f $HOME/compose/"$1"-compose.yml up -d

echo "Configurar nginx.conf para el proyecto"
cp $HOME/utils/nginx.conf /home/ubuntu/router/vhosts/"$1".conf
sed -i "s#project#$1#g" /home/ubuntu/router/vhosts/"$1".conf
docker exec -i nginx nginx -s reload

# crear registro en el DNS
# todavia no puedo hacerlo
# hello, hello


#!/bin/bash
HOME="/home/ubuntu/wordpress/webs"
# ${1} es PROJECT
# ${2} es PREFIX
DB_USER=<the_user>
DB_PASS=<the_pass>


docker exec -i db mysql -u${DB_USER} -p${DB_PASS} -e "DROP DATABASE IF EXISTS $1"
docker exec -i db mysql -u${DB_USER} -p${DB_PASS} -e "CREATE DATABASE IF NOT EXISTS $1"
docker exec -i db mysql -u${DB_USER} -p${DB_PASS} "$1" < $HOME/"$1"/"$2"_"$1".sql || exit 1
docker exec -i db mysql -u${DB_USER} -p${DB_PASS} "$1" \
  -e "update $2_options set option_value='http://$1.companyxyz.com' where option_id=1;" \
  -e "update $2_options set option_value='http://$1.companyxyz.com' where option_id=2;"


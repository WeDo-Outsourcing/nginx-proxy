#!/usr/bin/env bash


function run {
  cd /var/www/docker
  rm -rf nginx/sites-available/*

  apt-get update >> log/apt.log  2>&1 && apt-get install -y gawk >> log/apt.log  2>&1
  echo "Installed gawk..."

  if [[ "$1" == "no-skip" ]]; then
    apt-get install -y software-properties-common >> log/apt.log 2>&1
    add-apt-repository universe >> log/apt.log  2>&1
    add-apt-repository ppa:certbot/certbot >> log/apt.log  2>&1
    echo "Added PPA repository for Certbot..."
    apt-get update >> log/apt.log  2>&1
    apt install -y python-certbot-nginx >> log/apt.log  2>&1
    echo "--- Successfully installed Certbot ---"
  fi

  chmod -R 777 ./bin/ ./yaml-awk/
  setup_vhosts proxy.yml $1

  echo "--- Successfully set up virtual hosts ---"
}

function setup_vhosts {
  domains=$(cat $1 | ./bin/get_yaml_value "/active")
  space=' '
  list=${domains//,/$space}

  mkdir /etc/nginx/sites-available
  for x in $list ; do
      vhost $1 $x $2
  done

  cat /etc/nginx/sites-available/*
}

function vhost {
  filename="/etc/nginx/sites-available/$2.conf"
  cp ./default.conf ${filename}

  domain=$(cat $1 | ./bin/get_yaml_value "/$2/domain")
  port=$(cat $1 | ./bin/get_yaml_value "/$2/port")
  proxy=$(cat $1 | ./bin/get_yaml_value "/$2/proxy")

  sed -i "s/NGINX_DOMAIN/$domain/g" ${filename}
  sed -i "s/NGINX_PROXY/$proxy/g" ${filename}
  sed -i "s/NGINX_PORT/$port/g" ${filename}
}

run $1


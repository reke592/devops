#!/bin/bash

mkdir -p "secrets"

if [ ! -f "./secrets/mysql_root_passwd" ]; then
  printf "%s" "$(openssl rand -base64 12)" > "./secrets/mysql_root_passwd"
fi

if [ ! -f "./secrets/mysql_admin_passwd" ]; then
  printf "%s" "$(openssl rand -base64 12)" > "./secrets/mysql_admin_passwd"
fi

export STACK_NAME="customer_apps"
sudo docker stack deploy --compose-file "./compose.yaml" "$STACK_NAME"

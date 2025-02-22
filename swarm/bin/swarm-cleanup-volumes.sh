#!/bin/bash
export FILTER_NAME="$1"
export CLI_VERSION="28.0.0"

if [ -z "$FILTER_NAME" ]; then
  echo "Err. invalid filter name. usage: $(basename $0) <filter_name>"
fi

BIN="$(readlink "$0")"
BIN_DIR="$(dirname $BIN)"
STACKS_DIR="$(dirname "$BIN_DIR")/stacks"
TEMP_FILE="/tmp/swarm-volume-cleanup-compose-$(openssl rand -hex 8).yaml"

cat <<EOF >"$TEMP_FILE"
services:
  swarm-volume-cleanup:
    image: "docker:$CLI_VERSION-cli"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      NODE_ID: "{{.Node.ID}}"
    deploy:
      mode: global-job
      restart_policy:
        condition: none
    entrypoint:
      - sh 
      - -c
      - |
        set -xe
        docker volume ls --filter name="$FILTER_NAME" --filter "dangling=true" -q | xargs -r docker volume rm
        echo Done - $\$NODE_ID
EOF

cat "$TEMP_FILE"

read -p "Continue with deployment? [y/N]: " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "aborting deployment."
  exit 1
fi

sudo docker stack deploy --compose-file "$TEMP_FILE" maintenance
rm "$TEMP_FILE"

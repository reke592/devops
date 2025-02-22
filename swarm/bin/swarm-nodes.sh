#!/bin/bash
docker node ls --format '{{.ID}} {{.Hostname}}' | while read node_id node_name; do
  ip=$(docker node inspect "$node_id" --format '{{ .Status.Addr }}')
  labels=$(docker node inspect "$node_id" --format '{{json .Spec.Labels}}')
  echo "Id: $node_id, Node: $node_name, IP: $ip, Labels: $labels"
done

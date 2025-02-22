#!/bin/bash

sudo docker volume create grafana_data || true
sudo docker compose up -d

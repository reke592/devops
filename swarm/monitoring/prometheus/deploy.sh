#!/bin/bash

sudo docker stack deploy --compose-file "./compose.yaml" prometheus

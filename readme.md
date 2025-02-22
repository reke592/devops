## DevOps setup

## Installation

Clone the repository in manager node

```sh
git clone https://github.com/reke592/devops.git
```

Run the setup scripts

```sh
# add execute permission to setup shells
cd ./devops/swarm/setup
chmod -R 770 .

# for ubuntu, install docker
sudo ./setup-ubuntu.sh

# link shells in bin to /usr/local/bin
sudo ./setup-bins.sh
```

Initialize docker swarm

```sh
# check the machine ip
node-ip

# initialize the swarm
sudo docker swarm init --advertise-addr <ip_address>
```

Check node docker version, all swarm members must match the manager version.
> Avoid stack deployments in node if there is version mismatch

```sh
sudo docker node ls
```

## Deploy Monitoring Services

Cadvisor - to export container info

```sh
# navigate to service directory
cd ./monitoring/cadvisor

# deploy the cadvisor in all swarm nodes
sudo ./deploy.sh

# check deployment status
sudo ./ps.sh
```

Prometheus, Grafana - query and visualization. Better to centralize this service to a dedicated server.

```sh
# navigate to service directory
cd ./monitoring/prometheus

# creates a volume grafana_data and deploy the services using docker-compose up -d
sudo ./deploy.sh

# check deployment status using docker-compose ps
sudo ./ps.sh
```

## Sample Grafana Dashboard

- `./monitoring/prometheus/grafana/manager-node-dashboard.json` - for manager node, queries container RSS memory, CPU and disk usage.

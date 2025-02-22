### DevOps setup

### Troubleshooting

`docker swarm init` not working, 0.0.0.0:2377 already in used.

Check the process that occupies the port

```sh
# verify which process is running
sudo ss --tcp --listening --processes --numeric | grep ":2377"

# using the pid, read the exe
sudo readlink -f /proc/<pid>/exe

# if the process is /usr/bin/dockerd, try restarting the docker
sudo systemctl restart docker

# if restarting the service did not work, try to move the swarm directory and re-run the docker swarm init
sudo mv /var/lib/docker/swarm /var/lib/docker/swarm.old
```

Swarm corruption may also happen due to snap installation of docker. Possible chances, when the docker engine has been updated before creating the swarm, then after server restart the snap installation of docker takes over, resulting to unexpected downgrade of the engine. Make sure to remove the snap version of docker before running the setup installation `(./swarm/setup/setup-ubuntu)` as this may conflict. To remove the snap installation of docker: `sudo snap remove docker`.

Symptoms of swarm corruption due to snap version conflicts:

- after server restart, `docker info | grep Swarm` returns inactive and services created before did not run automatically or missing.
- when deploying stack in the current node, we see errors like `mkdir /var/lib/docker: read-only file system`
  - verify if it's true by running `touch /var/lib/docker/testfile`, if the file has been created, this means the docker you are using is a snap version, conflicting with the other installation.

### Installation

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

### Deploy Monitoring Services

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

### Sample Grafana Dashboard

- `./monitoring/prometheus/grafana/manager-node-dashboard.json` - for manager node, queries container RSS memory, CPU and disk usage.

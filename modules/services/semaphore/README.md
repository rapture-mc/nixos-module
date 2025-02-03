# Semaphore NixOS Module

## Overview
This module deploys [Semaphore](https://semaphoreui.com/) in a docker compose stack using [Arion](https://github.com/hercules-ci/arion) since no nixpkgs module exists for deploying Semaphore. Arion is used for language consistency and to utilize the NixOS module system.

## Features
- Kerberos Support (for Windows AD authentication integration)
- Easy docker container administration using [Lazydocker](https://github.com/jesseduffield/lazydocker)
- Automatic TLS reverse proxy support

## Deployment
### Deploy using:
```
megacorp.services.semaphore = {
  enable = true;
};
```
- This will deploy 2x containers (1x for semaphore and 1x for postgres) with Nginx serving as a reverse proxy on the same host. Service will fail if Lets encrypt can't obtain a SSL certificate for the host defined in "semaphore.fqdn" so ensure the necssary DNS, port forwards and firewall rules are setup prior.
- Postgres data is stored in a docker volume

### Activate Kerberos authentication using:
```
megacorp.services.semaphore = {
  enable = true;
  kerberos = {
    enable = true;
    kdc = "<domain-controller-hostname>";
    domain = "<domain-name>";
  };
};
```

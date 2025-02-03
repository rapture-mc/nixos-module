# Semaphore NixOS Module

## Overview
This module deploys [Semaphore](https://semaphoreui.com/) in a docker compose stack using [Arion](https://github.com/hercules-ci/arion) since no nixpkgs module exists for deploying Semaphore. Arion is used for language consistency and to utilize the NixOS module system.

## Features
- Kerberos Support (for Windows AD authentication integration)
- Easy docker container administration using [Lazydocker](https://github.com/jesseduffield/lazydocker)

# container-traefik

A Docker Compose container setup for [Traefik](https://traefik.io/).

## Table of contents

- [container-traefik](#container-traefik)
  - [Table of contents](#table-of-contents)
  - [Setup](#setup)

## Setup

0. Requirements

   - Docker
   - Docker Compose
   - htpasswd -> run this to install htpasswd:

        ```bash
        sudo apt update && sudo apt install apache2-utils
        ```

   - this setup assumes that [Cloudflare](https://www.cloudflare.com/) is the DNS provider for your domain.

1. Fix file permissions

    ```bash
    chmod +x init.sh
    chmod 600 ./config/certs/acme.json
    ```

2. Add environment variables

    Add the missing information for the environment variables:

    ```bash
    nano .env
    ```

3. Generate `traefik.yml` config file from `traefik.tpl` template file

    ```bash
    ./init.sh
    ````

4. Create docker network for traefik

    ```bash
    docker network create traefik-net
    ```

5. Start container

    ```bash
    docker-compose up -d
    ````

6. Stop container

    ```bash
    docker-compose down
    ```

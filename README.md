# container-traefik

docker compose container setup for [traefik](https://traefik.io/).

## setup

0. requirements

   - docker
   - docker-compose
   - htpasswd -> run this to install htpasswd:

        ```bash
        sudo apt update && sudo apt install apache2-utils
        ```

   - this setup assumes that [Cloudflare](https://www.cloudflare.com/) is the DNS provider for your domain.

1. fix file permissions

    ```bash
    chmod +x init.sh
    chmod 600 ./config/certs/acme.json
    ```

2. add environment variables

    ```bash
    nano .env
    ```

    add the missing information for the environment variables

3. generate traefik.yml config file from traefik.tpl template file

    ```bash
    ./init.sh
    ````

4. create docker network for traefik

    ```bash
    docker network create traefik-net
    ```

5. start container

    ```bash
    docker-compose up -d
    ````

6. stop container

    ```bash
    docker-compose down
    ```

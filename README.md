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

    Use the following command to create a username-password string:

    ```bash
    echo $(htpasswd -nb <user> '<password>')
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

6. First run

    - start the container for the first time. wait some time before proceeding
    - execute the following command to get the crowdsec bouncer key:

        ```bash
        docker compose exec -t crowdsec-server cscli bouncers add bouncer-traefik
        ```

    - use the output and add it to the `.env` file in the section `TRAEFIK_CONT_BOUNCER_KEY`
    - restart the container

7. enable crowdsec auto collection update via cron

    run the following command to edit the cron entries:

    ```bash
    sudo crontab -e
    ````

    And add this line:

    ```txt
    0 * * * * docker exec crowdsec cscli hub update && docker exec crowdsec-server cscli hub upgrade
    ```

8. add the crowdsec instance to the [crowdsec dashboard](https://app.crowdsec.net/)

   - login to the crowdsec dashboard
   - click on add instance
   - copy the key and run this command:

        ```bash
        docker exec crowdsec-server cscli console enroll <key>
        ```

9. Stop container

    ```bash
    docker-compose down
    ```

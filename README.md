# container-traefik

A Docker Compose container setup for [Traefik](https://traefik.io/).

## Table of contents

- [container-traefik](#container-traefik)
  - [Table of contents](#table-of-contents)
  - [Setup](#setup)
    - [0. Requirements](#0-requirements)
    - [1. Create an api key for Cloudflare](#1-create-an-api-key-for-cloudflare)
    - [2. Fix file permissions](#2-fix-file-permissions)
    - [3. Add environment variables](#3-add-environment-variables)
    - [4. Generate `traefik.yml` config file from `traefik.tpl` template file](#4-generate-traefikyml-config-file-from-traefiktpl-template-file)
    - [5. Create docker network for traefik](#5-create-docker-network-for-traefik)
    - [6. First run](#6-first-run)
  - [env file](#env-file)
  - [Usage](#usage)
    - [Start container](#start-container)
    - [Stop container](#stop-container)
    - [View the recent traefik logs](#view-the-recent-traefik-logs)
    - [Use the console within the container](#use-the-console-within-the-container)

## Setup

### 0. Requirements

- Docker
- (Docker Compose)
- htpasswd -> run this to install htpasswd:

    ```bash
    sudo apt update && sudo apt install apache2-utils
    ```

- this setup assumes that [Cloudflare](https://www.cloudflare.com/) is the DNS provider for your domain.

### 1. Create an api key for Cloudflare

- Go to [dash.cloudflare.com/profile/api-tokens](https://dash.cloudflare.com/profile/api-tokens)
- Click on `Generate new Token`
- Use the `Zone-DNS edit` template
- Set a meaningfull name like `traefik @ docker01`
- Make sure that there is a permission: `Zone - DNS - Edit`
- Add the permission: `Zone - Zone - Read`
- Add the zone ressource: `Add - All Zones`
- Leave the ttl empty
- Create the token

### 2. Fix file permissions

```bash
chmod +x init.sh
chmod 600 ./config/certs/acme.json
```

### 3. Add environment variables

Add the missing information for the environment variables:

```bash
nano .env
```

Use the following command to create a username-password string:

```bash
echo $(htpasswd -nb <user> '<password>')
```

Mark the `.env` file so it's not tracked by git:

```bash
git update-index --assume-unchanged .env
git update-index --assume-unchanged config/certs/acme.json
```

### 4. Generate `traefik.yml` config file from `traefik.tpl` template file

```bash
./init.sh
````

### 5. Create docker network for traefik

```bash
docker network create traefik-net
```

### 6. First run

1. Generate the crowdsec bouncer key:
   - start the container for the first time. wait some time before proceeding
   - execute the following command to get the crowdsec bouncer key:

        ```bash
        docker compose exec -t crowdsec-server cscli bouncers add bouncer-traefik
        ```

   - use the output and add it to the `.env` file in the section `TRAEFIK_CONT_BOUNCER_KEY`
   - restart the container

2. enable crowdsec auto collection update via cron

   - run the following command to edit the cron entries:

        ```bash
        sudo crontab -e
        ````

   - And add this line:

        ```txt
        0 * * * * docker exec crowdsec cscli hub update && docker exec crowdsec-server cscli hub upgrade
        ```

3. add the crowdsec instance to the [crowdsec dashboard](https://app.crowdsec.net/)

   - login to the crowdsec dashboard
   - click on add instance
   - copy the key and run this command:

        ```bash
        docker exec crowdsec-server cscli console enroll <key>
        ```

## env file

the .env file must include the following values:

```text
TRAEFIK_CONT_CF_DNS_API_TOKEN=""
TRAEFIK_CONT_ACME_EMAIL=""
TRAEFIK_CONT_MAIN_URL=""
TRAEFIK_CONT_SANS_URL=""
TRAEFIK_CONT_WEB_UI_URL=""
TRAEFIK_CONT_BASIC_AUTH=""
TRAEFIK_CONT_BOUNCER_KEY=""
```

- TRAEFIK_CONT_CF_DNS_API_TOKEN
    This var must contain the api token created in [4. Create an api key for Cloudflare](#4-create-an-api-key-for-cloudflare)
- TRAEFIK_CONT_ACME_EMAIL
    The email wich should be associated with the let's encrypt registration. e.g.: [info@example.com](mailto:info@example.com)
- TRAEFIK_CONT_MAIN_URL
    The main tld. e.g.: [example.com](https://example.com)
- TRAEFIK_CONT_SANS_URL
    A list of subdomains secured by this traefik instance. e.g.: [\*.example.com](https://*.example.com),[\*.host.example.com](https://*.host.example.comm)
- TRAEFIK_CONT_WEB_UI_URL
    The domain for the traefik web ui. e.g.: [traefik.host.example.com](https://traefik.host.example.com)
- TRAEFIK_CONT_BASIC_AUTH
    The user config create with this command `echo $(htpasswd -nb <user> '<password>')`
- TRAEFIK_CONT_BOUNCER_KEY
    This var must contain the api token created in [6. First run](#6-first-run)

## Usage

### Start container

```bash
docker compose up -d
````

### Stop container

```bash
docker compose down
```

### View the recent traefik logs

```bash
docker exec traefik-server cat /var/log/traefik/traefik.log
```

### Use the console within the container

```bash
docker exec -it traefik-server /bin/sh
```

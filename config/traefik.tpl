# Traefik API and dashboard configuration
api:
  dashboard: true
  #insecure: true

# Entrypoint configuration
entryPoints:

  web:
    address: ":80"

  websecure:
    address: ":443"

# Provider configuration
providers:

  # Docker provider configuration
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false

  # Directory provider configuration (dynamic)
  file:
    directory: "./dynamic-config"
    watch: true

# certificates resolvers config
certificatesResolvers:

  # lets encrypt
  lets-encrypt:
    acme:
      email: ${TRAEFIK_CONT_ACME_EMAIL}
      storage: acme.json
      dnsChallenge:
        provider: cloudflare
        delayBeforeCheck: 0

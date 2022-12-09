# Traefik API and dashboard configuration
api:
  dashboard: true
  #insecure: true

# Log setup
log:
  level: "INFO"
  filePath: "/var/log/traefik/traefik.log"
accessLog:
  filePath: "/var/log/traefik/access.log"
  bufferingSize: 100

# Entrypoint configuration
entryPoints:

  # http entrypoint
  web:
    address: ":80"
    http:
      redirections:
        entryPoint:
          to: "web"
          scheme: "https"

  # https entryPoint
  websecure:
    address: ":443"

# Provider configuration
providers:

  # Docker provider configuration
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false

  # SSL settings & secure header config
  ssl-config:
    filename: "./ssl-config.yml"
    watch: true

  # Directory provider configuration (dynamic)
  file:
    directory: "./dynamic-config/"
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
        delayBeforeCheck: 30
        resolvers:
          - "1.1.1.1"
          - "1.0.0.1"

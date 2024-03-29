# Traefik API and dashboard configuration
api:
  dashboard: true
  #insecure: true

global:
  checknewversion: true
  sendanonymoususage: false

# Log setup
log:
  level: "DEBUG"
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
          to: "websecure"
          scheme: "https"

  # https entryPoint
  websecure:
    address: ":443"
    http:
      middlewares:
        - default@file

# Provider configuration
providers:

  # Docker provider configuration
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false

  # Directory provider configuration (dynamic)
  file:
    directory: "./dynamic-config/"
    watch: true
    
  providersThrottleDuration: 10

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
          - "1.1.1.1:53"
          - "1.0.0.1:53"

#!/bin/bash

source .env

eval "cat <<EOF
$(<config/traefik.tpl)
EOF
" > config/traefik.yml
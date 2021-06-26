#!/usr/bin/env sh

set -e

#
# Utility functions
#

resolve_ip() {
  getent hosts ${DATAPLANE_HOSTNAME} 2>/dev/null | awk -e '{ print $1 }'
}

fail() {
  printf 'Error: %s\n' "${1}" >&2  ## Send message to stderr. Exclude >&2 if you don't want it that way.
  exit "${2-1}"                    ## Return a code specified by $2 or 1 by default.
}

create_dataplane() {
  DATAPLANE_HOSTNAME="$1"
  DATAPLANE_PUBLIC_PORT=$2
  DATAPLANE_LOCAL_PORT=$3
  DATAPLANE_RESOURCE="$4"
  DATAPLANE_NAME="${DATAPLANE_HOSTNAME}"

  #
  # Resolve IP address allocated to the "${DATAPLANE_NAME}" container
  #

  DATAPLANE_IP_ADDRESS=$( resolve_ip ${DATAPLANE_HOSTNAME} )
  if [ -z "${DATAPLANE_IP_ADDRESS}" ]; then
    fail "failed to resolve IP address allocated to the '${DATAPLANE_HOSTNAME}' container"
  fi
  echo "'${DATAPLANE_HOSTNAME}' has the following IP address: ${DATAPLANE_IP_ADDRESS}"

  #
  # Create Dataplane for "${DATAPLANE_NAME}"
  #

  echo "${DATAPLANE_RESOURCE}" | kumactl apply -f - \
    --var IP=${DATAPLANE_IP_ADDRESS} \
    --var PUBLIC_PORT=${DATAPLANE_PUBLIC_PORT} \
    --var LOCAL_PORT=${DATAPLANE_LOCAL_PORT}

  #
  # Create token for "${DATAPLANE_NAME}"
  #

  kumactl generate dataplane-token --name=${DATAPLANE_NAME} > /${DATAPLANE_NAME}/token
}

#
# Arguments
#

KUMA_CONTROL_PLANE_URL=https://kuma-control-plane:5682

FRONTEND_HOSTNAME=frontend
FRONTEND_PUBLIC_PORT=6060
FRONTEND_LOCAL_PORT=6060

BACKEND_HOSTNAME=backend
BACKEND_PUBLIC_PORT=7070
BACKEND_LOCAL_PORT=7070

#
# Configure `kumactl`
#

kumactl config control-planes add --name universal --address ${KUMA_CONTROL_PLANE_URL} --ca-cert-file /certs/server/cert.pem --client-cert-file /certs/client/cert.pem --client-key-file /certs/client/cert.key --overwrite

#
# Create Dataplane for `frontend` service
#

create_dataplane "${FRONTEND_HOSTNAME}" ${FRONTEND_PUBLIC_PORT} ${FRONTEND_LOCAL_PORT} "
type: Dataplane
mesh: default
name: frontend
networking:
  address: {{ IP }}
  inbound:
  - port: {{ PUBLIC_PORT }}
    servicePort: 18080
    tags:
      kuma.io/service: frontend
      kuma.io/protocol: http
      kuma.io/zone: eu-west-1
  outbound:
  - port: 5000
    service: backend"

#
# Create Dataplane v1 for `backend` service
#

create_dataplane "${BACKEND_HOSTNAME}" ${BACKEND_PUBLIC_PORT} ${BACKEND_LOCAL_PORT} "
type: Dataplane
mesh: default
name: backend
networking:
  address: {{ IP }}
  inbound:
  - port: {{ PUBLIC_PORT }}
    servicePort: 18080
    tags:
      kuma.io/service: backend
      kuma.io/protocol: http
      kuma.io/zone: us-east-1
  outbound:
  - port: 5000
    service: frontend"

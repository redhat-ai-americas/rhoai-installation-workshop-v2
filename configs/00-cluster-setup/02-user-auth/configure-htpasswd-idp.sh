#!/usr/bin/env bash
# shellcheck disable=SC1091

set -euo pipefail

# Appends the HTPasswd identity provider to the cluster OAuth configuration
# without replacing any identity providers that already exist, and pre-maps
# HTPasswd identities onto users that already exist so that 'claim' mapping
# cannot collide with users created by another identity provider (e.g. SSO).
#
# Run after `oc apply -k configs/00-cluster-setup/02-user-auth` so that the
# htpasswd-local secret exists.

DIR="$(cd "$(dirname "$0")" && pwd)"
IDP_NAME=htpasswd
SECRET_NAME=htpasswd-local
HTPASSWD_FILE="${DIR}/.htpasswd"

if [ ! -f "${HTPASSWD_FILE}" ]; then
  echo "Error: ${HTPASSWD_FILE} not found. Run 01-generate-htpasswd/generate-htpasswd.sh first." >&2
  exit 1
fi

# Users defined in the htpasswd file (stays in sync with generate-htpasswd.sh)
USERS=$(cut -d: -f1 "${HTPASSWD_FILE}" | grep -v '^$' || true)

PROVIDER='{"name":"'"${IDP_NAME}"'","type":"HTPasswd","mappingMethod":"claim","htpasswd":{"fileData":{"name":"'"${SECRET_NAME}"'"}}}'

EXISTING=$(oc get oauth cluster -o jsonpath='{.spec.identityProviders[*].name}' 2>/dev/null || true)

if echo "${EXISTING}" | grep -qw "${IDP_NAME}"; then
  echo "Identity provider '${IDP_NAME}' already configured - nothing to do."
elif [ -z "${EXISTING}" ]; then
  echo "No identity providers configured - adding '${IDP_NAME}' as the first one."
  oc patch oauth cluster --type=json \
    -p '[{"op":"add","path":"/spec/identityProviders","value":['"${PROVIDER}"']}]'
else
  echo "Existing identity providers found (${EXISTING}) - appending '${IDP_NAME}' alongside them."
  oc patch oauth cluster --type=json \
    -p '[{"op":"add","path":"/spec/identityProviders/-","value":'"${PROVIDER}"'}]'
fi

# Pre-map htpasswd identities onto existing users so that 'claim' mapping
# cannot collide with users created by another identity provider (e.g. SSO).
for u in ${USERS}; do
  if oc get user "${u}" >/dev/null 2>&1; then
    if oc get identity "${IDP_NAME}:${u}" >/dev/null 2>&1; then
      echo "Identity ${IDP_NAME}:${u} already mapped to user ${u}."
    else
      uid=$(oc get user "${u}" -o jsonpath='{.metadata.uid}')
      oc apply -f - <<EOF
apiVersion: user.openshift.io/v1
kind: Identity
metadata:
  name: ${IDP_NAME}:${u}
providerName: ${IDP_NAME}
providerUserName: ${u}
user:
  name: ${u}
  uid: ${uid}
EOF
      oc patch user "${u}" --type=json \
        -p '[{"op":"add","path":"/identities/-","value":"'"${IDP_NAME}:${u}"'"}]'
      echo "Pre-mapped ${IDP_NAME}:${u} onto existing user ${u}."
    fi
  else
    echo "User ${u} does not exist yet - 'claim' mapping will create it on first login."
  fi
done

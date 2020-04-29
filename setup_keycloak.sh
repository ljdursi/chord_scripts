#!/usr/bin/env bash
# Start up keycloak and config for new user & client
#
set -euo pipefail

source config.sh

readonly KC_PATH=/opt/keycloak/bin

echo "# Configuring admin user..."
${KC_PATH}/add-user-keycloak.sh -r master -u ${ADMIN} -p ${ADMINPWD}

echo "# Starting up keycloak standalone"
systemctl enable keycloak
systemctl start keycloak
sleep 10

echo "# Connecting to keycloak..."
${KC_PATH}/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user ${ADMIN} --password ${ADMINPWD}

echo "# Creating realm.."
${KC_PATH}/kcadm.sh create realms -s realm=${REALM} -s enabled=true

echo "# Creating user and restarting"
${KC_PATH}/add-user-keycloak.sh -r ${REALM} -u ${USER} -p ${USERPWD}
systemctl restart keycloak
sleep 10
${KC_PATH}/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user ${ADMIN} --password ${ADMINPWD}

echo "# Creating client.."
ID=$(${KC_PATH}/kcadm.sh create clients -r ${REALM} -s clientId=${CLIENTID} -s 'redirectUris=["*"]' -i)

echo "# Client config follows..."
${KC_PATH}/kcadm.sh get clients/${ID}/installation/providers/keycloak-oidc-keycloak-json -r ${REALM}

echo "# User follows..."
${KC_PATH}/kcadm.sh get users -r ${REALM}

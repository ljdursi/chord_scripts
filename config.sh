#!/usr/bin/env bash
set -euo pipefail

readonly ADMIN=kcadmin ADMINPWD=xxx
readonly USER=chordxx USERPWD=xxx
readonly SITEID=chord_xxx
readonly CLIENTID=${SITEID}
readonly REALM=chordxx

readonly HOSTNAME=chordbxxxx
readonly DOMAIN=xxxx.yyyy
readonly FULLHOST=${HOSTNAME}.${DOMAIN}

readonly CHORD_TEMP_PATH=${HOME}/chord_temp
readonly CHORD_DATA_PATH=${HOME}/chord_data

export ADMIN ADMINPWD
export USER USERPWD
export SITEID
export CLIENTID
export REALM
export HOSTNAME DOMAIN FULLHOST
export CHORD_TEMP_PATH CHORD_DATA_PATH

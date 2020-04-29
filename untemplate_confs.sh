#!/usr/bin/env bash
set -euo pipefail

source config.sh

for file in *.template
do
    basefile="${file%.*}"
    cat $file \
        | envsubst '$ADMIN $ADMINPWD $USER $USREPWD $SITEID $CLIENTID $REALM $HOSTNAME $DOMAIN $FULLHOST $CHORD_TEMP_PATH $CHORD_DATA_PATH' \
	> $basefile
done

mkdir -p ${CHORD_TEMP_PATH}
mkdir -p ${CHORD_DATA_PATH}
cp auth_config.json ${CHORD_DATA_PATH}/.auth_config.json
cp instance_config.json ${CHORD_DATA_PATH}/.instance_config.json
